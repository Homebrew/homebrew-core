class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.37.1",
      revision: "997d406ec25832e7d16f140d110e4016f908d8cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "634d24d6976514c7b6541cd586061a20669f05f1389176cbaa2271ed35d07785"
    sha256 cellar: :any_skip_relocation, big_sur:       "20b4e8843b481938cb47faab1110bd49727833d52fcee089631ccdb2b8b2ff22"
    sha256 cellar: :any_skip_relocation, catalina:      "20b4e8843b481938cb47faab1110bd49727833d52fcee089631ccdb2b8b2ff22"
    sha256 cellar: :any_skip_relocation, mojave:        "20b4e8843b481938cb47faab1110bd49727833d52fcee089631ccdb2b8b2ff22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9072e28e205fc9be7b27eabe6e76c87abc3417bb9799b3b3bc2d49ede5176550"
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
