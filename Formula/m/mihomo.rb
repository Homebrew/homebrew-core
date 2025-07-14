class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.11.tar.gz"
  sha256 "72730aff2c89f1cba60bfc9318e17ac8161db4e6c69bd24b54eb37f9fa646540"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da4a0bc0ffa33edd0c6ba6646c12a823256b3414e204d1b71aa95dc4767804c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3578e88f6e67f3707cce91af40c31efe6cf422f9c0d94ccc7c8b199bf0fc83b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6a94ad17d00ee381f2d5a986fefff4727ce841e49e43669517dc60f66db3988"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be0f6b0d2db2b322c9819187e212f26754503b74453db2585d104ab874faafd"
    sha256 cellar: :any_skip_relocation, ventura:       "f89010117ec42805d22d0b2c217be33d74c5709b349b6ef993a41cbef3683286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14b751f50e16f8ab95d5dc247d83ec5a9ec25f342f0a39125ee3664ea33f6295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb23e788a5c8a320ff49e681a583e262c9dfd4553e6df0ad1ecaee558250ebe"
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
