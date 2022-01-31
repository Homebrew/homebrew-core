class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.39.0",
      revision: "2dab5d0bca96cadcd3efa627d26ee419f322b64e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e6187bf8ab9d92393182bb282b22e141e0119c3af8475b4e6641387e9fd686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37e6187bf8ab9d92393182bb282b22e141e0119c3af8475b4e6641387e9fd686"
    sha256 cellar: :any_skip_relocation, monterey:       "02061872c4a47b00760d21c4f540a2b378a8d32e329196993597f60798177e5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "02061872c4a47b00760d21c4f540a2b378a8d32e329196993597f60798177e5e"
    sha256 cellar: :any_skip_relocation, catalina:       "02061872c4a47b00760d21c4f540a2b378a8d32e329196993597f60798177e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a9740f584d5c340682d75886b8f93b594342c0c77a67ea887611199f5ba59c"
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
