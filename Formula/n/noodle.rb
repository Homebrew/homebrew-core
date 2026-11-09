class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://github.com/noodle-rest/noodle/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "e00a6cc6e01c57dc49e3c9ffa004f88daf6d77d9043674b257aa5b5c59e25c63"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "703150c9f5e580cfab382e5087051d97f6e78b2b54f35fe078a65720e5c07625"
    sha256 arm64_tahoe:       "487ae46fa54f9cbd72702596f0fa96e254b83dcd567eea7e3f3e864fce9f959c"
    sha256 arm64_sequoia:     "e152641a0b21283dc8134f3223ec97434bcedfc4bc7c3593244b0f81a886cc85"
    sha256 arm64_linux:       "4d752ffdb638b30e7ff7f288c8a7154574cff0e7afcaada8add8929a4385abbf"
    sha256 x86_64_linux:      "4aa8d977704afae9fcf487bc939d54ad887f3b32ce3d1d4e24c8570ab0fbc6a7"
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
      url "https://raw.githubusercontent.com/noodle-rest/noodle/refs/tags/v#{LATEST_VERSION}/package.json"
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
