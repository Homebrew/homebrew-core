class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.30.tar.gz"
  sha256 "ee8a7107707e4bd485460139b1944e7be30016393783f2b4e928c14880c8ca8b"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd0ba3de15b3aa9732a3238add2836d8ac8b80aca7f87ec0ff975478db83274c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5749a3a555e8b201bba11d7964f3a9382cd608c0f58a00431bf6f15f67c61edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885562801fab408e7eb5f11ff71959bce60cb43522d7cd1a545b11ffa3c33afb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc22c33a08be679c36344ae1a7169da88e9bc90b902e9df9dc7ee1b8299d406a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3e4320c95fce0ae4f64491d586e136fb82b3747c2e8f0b1610a4c91c92172c"
    sha256 cellar: :any,                 x86_64_linux:  "48e926948b13bc5f49a5417556a0a479007bf89186277a63a25307245ddfbbe9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

    (buildpath/"config.yaml").write <<~YAML
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}/mihomo/config.yaml.
    EOS
  end

  service do
    run [opt_bin/"mihomo", "-d", etc/"mihomo"]
    keep_alive true
    working_dir etc/"mihomo"
    log_path var/"log/mihomo.log"
    error_log_path var/"log/mihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mihomo -v")

    (testpath/"mihomo/config.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end
