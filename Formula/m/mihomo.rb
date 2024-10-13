class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.18.9.tar.gz"
  sha256 "8f64a5585b7bbbd65b83552a6cdc7a443fd47b2594f5a3ff72f02c8382d5e8da"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c657329510466d730e838ffc3f9daf68e1f32e9102fa30250f365e4b8db128c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dc10f90922f0c4c7afd2caea42da71a7667372328b0e19c6835ac7fa6ee7c5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bc92aaf66aa32b114d43fb98a4858c6d6333c08420bb11d04a037bf2b4120e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "36bc2bf53f0196020b8cb502505aeac881f12f7d7726c29c1fa70aa7cb5d264e"
    sha256 cellar: :any_skip_relocation, ventura:       "5e7bb34bafa2aebe48c9a9afced9ea0dc4a5d9113b67884873e153530f37ac4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3dad291f425e00c7cc811c894a96b757d5167bbfd39e0e0d0a09ed3e7db69c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", "-tags", "with_gvisor", *std_go_args(ldflags:)

    (buildpath/"config.yaml").write <<~EOS
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    EOS
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

    (testpath/"mihomo/config.yaml").write <<~EOS
      mixed-port: #{free_port}
    EOS
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end
