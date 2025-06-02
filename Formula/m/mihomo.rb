class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.10.tar.gz"
  sha256 "a0ca7bb23fcfa067e8a58a9618879a507881dbca321a8eb0550948b1d26296c0"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e28b3821978a0cceeef732f9d427c4353b70fd4f82720f6ac190855527f09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034cc7e6fca1de4d05c46384a80a02f85c648f98e7a171ba1e6e02fa33268aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a844f3c640b9c3c3f8f713e26adddb1909b19c7543169dd0befd49d1ab55195"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4dec29cf05cab364e8eb24e69e051c24d8db396a95a8702965fd43efa4004ea"
    sha256 cellar: :any_skip_relocation, ventura:       "43f8f4b686fc953e0368ff758aa803ef7f0bbc415733d2d29645c19444861785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e64c1d023fdaccf392c0bd5cc3901f2ffc59397667547b3e36ea814864df1b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87bbcad993d18333922848b275de8ac461676ab5c0045ae66e9f87523716f9fa"
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
