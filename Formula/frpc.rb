class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.44.0",
      revision: "8888610d8339bb26bbfe788d4e8edfd6b3dc9ad6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2235a157bd9d1adeee488e098be3b14724291ad3a759147d455ae669be9174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a2235a157bd9d1adeee488e098be3b14724291ad3a759147d455ae669be9174"
    sha256 cellar: :any_skip_relocation, monterey:       "158d68417ba4f5db350720b26a3b46b0e0957a4aab3c64a543ac0b983d028242"
    sha256 cellar: :any_skip_relocation, big_sur:        "158d68417ba4f5db350720b26a3b46b0e0957a4aab3c64a543ac0b983d028242"
    sha256 cellar: :any_skip_relocation, catalina:       "158d68417ba4f5db350720b26a3b46b0e0957a4aab3c64a543ac0b983d028242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228041e37e00d32bfa6d360a275380dddb5b820540c41d5d889873fd0f4da856"
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
