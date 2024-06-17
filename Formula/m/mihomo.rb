class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.18.5.tar.gz"
  sha256 "205f6695ad19e232227c7e31da157860da9b2c4678900af9ebaf7e46c00c68c0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69f88643f5dced274ace1aa371bc561d23371a1ddacde58e51fe84e58bfd2b70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9467963ea2d56ac31c7132e16cd922ea018f646f7c5f87b69bb11b1bbfc455f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "012b33abb9df12bb742c92e7e943e4ddec49ca39a75216744ece182adf79d473"
    sha256 cellar: :any_skip_relocation, sonoma:         "874640ce9e57cf4bb171d582983a4f06b0a9b973620f21efbd773a00d4922c22"
    sha256 cellar: :any_skip_relocation, ventura:        "5741fe58ae447106a9928f0007a1ca7de907ade95a9ade22df56523cf3ac9aa2"
    sha256 cellar: :any_skip_relocation, monterey:       "9b45de5ab452beda122f13470efc6fdddc1253e9370674d55d3155862b2f7ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2c058f622eeb6ac2608d5cf7eaf9d8fdc52992becb4f2b5cc1b4854cd93498e"
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
