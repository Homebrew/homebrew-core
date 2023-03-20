class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.48.0",
      revision: "8fb99ef7a99c7a87065247d60be4a08218afa60b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f1fa93135b4a22ab1ba828631ebe459cb276fc96692d05d2a98d3f6b3405544"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1fa93135b4a22ab1ba828631ebe459cb276fc96692d05d2a98d3f6b3405544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f1fa93135b4a22ab1ba828631ebe459cb276fc96692d05d2a98d3f6b3405544"
    sha256 cellar: :any_skip_relocation, ventura:        "7c7b0aec06a94fe01ac9c9028aaedd42211a113b62d275227bbbbb9866aa252c"
    sha256 cellar: :any_skip_relocation, monterey:       "7c7b0aec06a94fe01ac9c9028aaedd42211a113b62d275227bbbbb9866aa252c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c7b0aec06a94fe01ac9c9028aaedd42211a113b62d275227bbbbb9866aa252c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0039eaf4e8d17f289c2b7edb65418106e272a66ef5f22afa13f4d25b884cff73"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.ini" => "frp/frpc.ini"
    etc.install "conf/frpc_full.ini" => "frp/frpc_full.ini"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.ini"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "local_port", shell_output("#{bin}/frpc http", 1)
    assert_match "local_port", shell_output("#{bin}/frpc https", 1)
    assert_match "local_port", shell_output("#{bin}/frpc stcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc tcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc udp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc xtcp", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc status -c #{etc}/frp/frpc.ini", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc reload -c #{etc}/frp/frpc.ini", 1)
  end
end
