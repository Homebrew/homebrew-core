class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.41.0",
      revision: "10f26201316ff99b4cd6bd3fde9526e1c9c5a95a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd9b944a6b068e5ad0787045e2b9393348d0d5f4fc9065c2f5f3597503f9c3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcd9b944a6b068e5ad0787045e2b9393348d0d5f4fc9065c2f5f3597503f9c3d"
    sha256 cellar: :any_skip_relocation, monterey:       "fad1fc60f7b4929af689aedb49045cc6d46197bc9aa588749b779433c362c0fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad1fc60f7b4929af689aedb49045cc6d46197bc9aa588749b779433c362c0fc"
    sha256 cellar: :any_skip_relocation, catalina:       "fad1fc60f7b4929af689aedb49045cc6d46197bc9aa588749b779433c362c0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f940e4dde4ad137d175edfb9171a13f89d3dba71f45eef5249b9c3c3cbe9598c"
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
