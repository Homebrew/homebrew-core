class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "08a9505810c8eba1d601ab0db87ea1bd82e3b5f9b2ba91484496e90adad2751d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "1a6f722524582cb3d967c50e4e3cf2b6dd692039cce20816cc68dc6239dc5717"
    sha256 arm64_tahoe:       "a7b824da883149a39831b7966d39ca7d9fcd6d978806a7d856878be59b765bef"
    sha256 arm64_sequoia:     "a4176f31cf8cc37cbd327de858ed43c9f994adde445cc4649fdeed8359c33f36"
    sha256 arm64_linux:       "fd13e574d828c1c03c874ee0b9bdecb88cb30b0c2f3d1255b3d9cd67f747cdb6"
    sha256 x86_64_linux:      "c5685984aa0ba8ea7a72e55c93c85077ce6bf3fcd94ce4e8f7c2ae76ab265103"
  end

  depends_on "bun" => :build
  # TODO: Use zig when Noodle's OpenTUI build supports Zig 0.17.
  # https://github.com/anomalyco/opentui/pull/1586
  depends_on "zig@0.16" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.5.14.tar.gz"
    sha256 "0e092b7405934c3a30f6eca2cb6e35eb00d9d8948d15daa69af2371e1e641a6e"

    livecheck do
      url "https://raw.githubusercontent.com/wilfredinni/noodle/refs/tags/v#{LATEST_VERSION}/package.json"
      strategy :json do |json|
        json.dig("dependencies", "@opentui/core")
      end
    end
  end

  deny_network_access!

  def fetch
    ENV["BUN_INSTALL_CACHE_DIR"] = buildpath/"bun-cache"
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    ENV["BUN_INSTALL_CACHE_DIR"] = buildpath/"bun-cache"
    resource("opentui").stage(buildpath/"opentui")
    system "bun", "run", "build:homebrew",
           "--offline",
           "--opentui-source", buildpath/"opentui",
           "--zig", formula_opt_bin("zig@0.16")/"zig",
           "--cc", ENV.cc
    bin.install "noodle"
    pkgshare.install "LICENSE"
    pkgshare.install "opentui/LICENSE" => "LICENSE.opentui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noodle --version")
    system bin/"noodle", "collection", "create", "brew-test", "--output", testpath, "--json"
    collection = testpath/"brew-test"
    (collection/"probe.yml").write <<~YAML
      name: Probe
      method: GET
      url: http://127.0.0.1:1
      scripts:
        pre: |-
          await Promise.resolve();
          if (noodle.crypto.randomBytes(4, "hex").length !== 8)
            throw new Error("homebrew-crypto-failed");
          throw new Error("homebrew-quickjs-ok");
    YAML
    inspected = JSON.parse(shell_output("#{bin}/noodle collection inspect #{collection} --json"))
    assert_equal 2, inspected.fetch("data").fetch("requestCount")
    output = shell_output("#{bin}/noodle request run probe --collection #{collection} --noproxy --json", 1)
    result = JSON.parse(output).fetch("data").fetch("result")
    assert_equal ["script"], result.fetch("failureCategories")
    assert_equal "homebrew-quickjs-ok", result.fetch("scripts").fetch("results").first.fetch("error").fetch("message")
  end
end
