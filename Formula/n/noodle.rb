class Noodle < Formula
  desc "Terminal REST client with file-based collections"
  homepage "https://noodlerest.dev"
  url "https://github.com/wilfredinni/noodle/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "8acef1480b991be5d6acf295865c82d2157ec2bcba33c39bd6f49ba91133baf0"
  license "Apache-2.0"

  bottle do
    sha256 arm64_golden_gate: "b0e13398a339cee8d88b38e762aa7dfbc439e26d5decdbadfa11e4399b4314e2"
    sha256 arm64_tahoe:       "65e773afb70d92cbf49842b9f8e49cf33576c3281c37a1e501b72f5476efa641"
    sha256 arm64_sequoia:     "642c6916dac0b9de68d3630476e10731b2790bd1200efbd634e937b049501309"
    sha256 arm64_linux:       "7ca41bc126e8d0889ff6fa886f82a3592182b6a0e7caa35faeda4a49ef6b1df6"
    sha256 x86_64_linux:      "23309bf622c532f06c7d39f37c7fff9220c86aad34cba61da2d5b3a32cf26141"
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
