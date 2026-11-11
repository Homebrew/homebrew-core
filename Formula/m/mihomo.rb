class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.34.tar.gz"
  sha256 "e3284a44f1052f1c454c90d418faa244516c2470bf232b455ea18fc4f5fa6028"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14aed3509356db300d75d93310c6e5272b90d91e411f99b2b259433ccad9c558"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b946845f72c66359177a7442fb5974aa96ba393c3820d18ccd19d91adbcb87e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69376c4997294ffc054eee370b3cd551e8201c8bc63d807b4e0c7a1b8431aec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b8076b33b5e557926d5ac0c8a1ad558b770718482942b704924ce397458bcc3"
    sha256 cellar: :any,                 x86_64_linux:      "3e03e09b198e09d709c26a9eb9dfda65328d2575e7c17d87093c5c92105f4655"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
