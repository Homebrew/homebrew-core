class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "2c40a5b53cc500b846cf966f21eeacea070a4377833e7dff07b63a53f7213db8"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3469b43eb09a6da49d4b92e9af7c4918d973cb41099e859afaf58442dd9d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07d259831b4a10e8705607b6b8efdcfb6b663ebd6703f6405c94fbb268284277"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d7f8cfbdf9e2718c7ca321b50dbdb3d5acd554022fadfee346c0fc4dc8e2313"
    sha256 cellar: :any_skip_relocation, sonoma:        "857987534228946dbd55e3a797774a48848ae1d17a476f46dd35ea3578b1086e"
    sha256 cellar: :any_skip_relocation, ventura:       "e2e7725db034986cdecc1832063fc655c5548287fd2b0a62a7d0ce867f85f487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06787de0535f23ad8e2c110b1693a20e82b5b162156f68028738171e05bee806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a611c564dadf8431a43c6c5e207fc15b14591a60e909d9368a254f1fad79bdc"
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
