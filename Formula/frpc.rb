class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.40.0",
      revision: "ce677820c6d8dbcfebf9f3a581453192a95f91e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197c1d06f3092fee7628bf36e9618ae33f8248c99ad91140b3a26720dedc504b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "197c1d06f3092fee7628bf36e9618ae33f8248c99ad91140b3a26720dedc504b"
    sha256 cellar: :any_skip_relocation, monterey:       "cb65642e995899d70b12df9f3b9b999e6bec0d46b8020663832935d6319bf53f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb65642e995899d70b12df9f3b9b999e6bec0d46b8020663832935d6319bf53f"
    sha256 cellar: :any_skip_relocation, catalina:       "cb65642e995899d70b12df9f3b9b999e6bec0d46b8020663832935d6319bf53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5e0335f891f0e1707fe6a1158a5e6f02c1b7fc109a6c7237a0bb91e1ef4d62"
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
