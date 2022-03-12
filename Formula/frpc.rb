class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.40.0",
      revision: "ce677820c6d8dbcfebf9f3a581453192a95f91e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b5f6ea3236c1ad15afcc0c8a2bce3302c6f92bd9c07b0644728cd4bef43ea4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47b5f6ea3236c1ad15afcc0c8a2bce3302c6f92bd9c07b0644728cd4bef43ea4"
    sha256 cellar: :any_skip_relocation, monterey:       "c32158b791443fda42fe50fee1690e03ba64230e37d0d9c6e1fecc19d38a5f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "c32158b791443fda42fe50fee1690e03ba64230e37d0d9c6e1fecc19d38a5f19"
    sha256 cellar: :any_skip_relocation, catalina:       "c32158b791443fda42fe50fee1690e03ba64230e37d0d9c6e1fecc19d38a5f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f613b058435aba5764d0fc27051ef0622568c0b0f036e2011b1c4acb3cd0163b"
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
