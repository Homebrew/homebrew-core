class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.27.tar.gz"
  sha256 "5d90ebe9057b2d996ba4bae237f4a277101d72a923117b4ae0dd97d0c7dc584f"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f102384b7c8989ab2c91a996be2092315291b867a3196415c24edec62cc0811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995dd7e4fa34d260fadb392f038393a2577b920fe634afa59205aa69338a5430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d365298d6700b29a280729b2db28c069fb6a01405537ee3d14767b263d67e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc8fd1786d0912f0fe1c6152b547873b9caad2da9c58bcf1a729aa661546ed81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23fd91dd72a4006dbf385c0c8c753ae89953541d457ae8d038ac49be1bef1acc"
    sha256 cellar: :any,                 x86_64_linux:  "f9a935d26df03e7b814dd63d6940bc2904944ae288e26399fdbbff6bc3a07e47"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
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
