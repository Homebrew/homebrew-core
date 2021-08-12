class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.37.1",
      revision: "997d406ec25832e7d16f140d110e4016f908d8cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "479f16efe4cd84aab82c9ed5b9faab80efe43c6241dfe634c391ae8377363237"
    sha256 cellar: :any_skip_relocation, big_sur:       "97c8de1d03db9974378e144e8f21e2c2797b68205e82f40822f699a4686bda46"
    sha256 cellar: :any_skip_relocation, catalina:      "97c8de1d03db9974378e144e8f21e2c2797b68205e82f40822f699a4686bda46"
    sha256 cellar: :any_skip_relocation, mojave:        "97c8de1d03db9974378e144e8f21e2c2797b68205e82f40822f699a4686bda46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7738425459a3304854d9a9cd1c87880657d5911a430d35a6ca4fe881100fe536"
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
