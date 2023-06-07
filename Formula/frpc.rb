class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.49.0",
      revision: "0d6d968fe8b58a36903bfe2c60a0ce8c218a63ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e47dcf0e9e01a8c4f1df20d4ee0b035d8bd53f25340c56f9aa1dadb4ebb0ad14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47dcf0e9e01a8c4f1df20d4ee0b035d8bd53f25340c56f9aa1dadb4ebb0ad14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e47dcf0e9e01a8c4f1df20d4ee0b035d8bd53f25340c56f9aa1dadb4ebb0ad14"
    sha256 cellar: :any_skip_relocation, ventura:        "d56068f54cef8839e326d442d8179e05d668eb4043eacc56a1d2e3841365ce5e"
    sha256 cellar: :any_skip_relocation, monterey:       "d56068f54cef8839e326d442d8179e05d668eb4043eacc56a1d2e3841365ce5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d56068f54cef8839e326d442d8179e05d668eb4043eacc56a1d2e3841365ce5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1053de8c95e8d964ab302e449e1542c81ba8464c76d7ee9bf189cfeebb0376a5"
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
