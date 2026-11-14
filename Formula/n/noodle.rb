class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://github.com/noodle-rest/noodle/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "5f6bbf259008ce1c76faf29ea8176985dd64c72535ced78ecde9ab37fea67eda"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "ad5da1240ccb26d2688b4679bf1c3cd8788ea67b302a83b6131ff1ea54eba5fb"
    sha256 arm64_tahoe:       "e4a020c0372a95eb620e36112d2c1698760c8facbc0691c9362f6797ebbfa4ef"
    sha256 arm64_sequoia:     "152a541f8a038ea2715dc3a89d0f19dbf2c458788c80afc2f176a419d60e3838"
    sha256 arm64_linux:       "8b581407d2b050aefa7fc560915d69c225a54987582136c19bb2070237279d66"
    sha256 x86_64_linux:      "672f3fbca81074b75d09e2ee56340fe8f69406290b7149756794dd45fb814b62"
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
