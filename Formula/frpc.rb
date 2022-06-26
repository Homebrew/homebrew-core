class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.43.0",
      revision: "fe5fb0326b2aa7741d5b5d8f8c4c3ca12bb4ed91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85a02fbea44970f091539f3bdf90280f35993f866b943af012a43354769be64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a85a02fbea44970f091539f3bdf90280f35993f866b943af012a43354769be64"
    sha256 cellar: :any_skip_relocation, monterey:       "650e98414d94f8419f96af47497bdd9413e3e6c4816042e916678f167ec6b5a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "650e98414d94f8419f96af47497bdd9413e3e6c4816042e916678f167ec6b5a5"
    sha256 cellar: :any_skip_relocation, catalina:       "650e98414d94f8419f96af47497bdd9413e3e6c4816042e916678f167ec6b5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f7df2d38baa038e833fa6a3cf9b8b1dfc9019a6789bda6efba9e8da09c1dcb"
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
