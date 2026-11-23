class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://github.com/noodle-rest/noodle/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e0445156fafdb76deb934cbe6ab01577c57284f40c4dcb8733f721f83092ecf6"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "d615e5f3c331c90abcbbb9e73887c88f723be6c3ee3d70488c577345a25768b7"
    sha256 arm64_golden_gate: "b661f550fd34ee2dc85a70085f8f93ecd5b4658b6b475e12584a08242e37eb3f"
    sha256 arm64_tahoe:       "f9fcbd40c03b9f0a5e6cd2204a2a07f7c5dd36192f89efde33606f79ae313803"
    sha256 arm64_sequoia:     "b9b1853902e09e431cda89971e338097807d6fa8922c6ebb60bd249670199d59"
    sha256 arm64_linux:       "861752fe6f943e4d0b2742d1a6b8de8d9c481a2dc605cc8911ce43ba534ed9d7"
    sha256 x86_64_linux:      "3d4651e5a39ea7402bfa8be43291109da2408d0bd986667471d61b68d48b1c21"
  end

  depends_on "bun" => :build
  depends_on "zig" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  resource "opentui" do
    url "https://github.com/anomalyco/opentui/archive/refs/tags/v0.9.0.tar.gz"
    sha256 "d341c779acf0ee265500fdddf74ab6704b95715dd918d0c019d0749a5b30be40"

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
           "--zig", formula_opt_bin("zig")/"zig",
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
