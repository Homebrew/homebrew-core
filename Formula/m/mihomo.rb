class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.14.tar.gz"
  sha256 "e1b8ac28978e56422db5a6d303599aea64147fa4e6a6930094b2fbb33c4d5d4d"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4352748d27bd34d5ac809ddd67a3b65a22d07832e21b9c9fb3632cde3fc1620a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4209255aba655a85cba1fbba3d6e5dc819656c5c47e08670f00d6b8f2d57151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2b3a4dffce202c30a3dc3c849b6a3a560082ed91e8bef3782d60818a45ac18"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fe2915ec6044ad215b343d1d11af0d9253c21156307737709e6b2efbbc282d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e5987de40f41d0d139d070ad6a1ae76e8c095fb9c3672877b917f0cbb615c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc57ee6d8fe8c64c2f44476a3c1533ce670ef04aebe15f5c3a0d4956196d593"
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
