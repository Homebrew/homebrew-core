class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.42.0",
      revision: "eb1e19a8212061e56a43ce798a231cd64cce989d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4906c6d01ea4dc417f249425150e635a652630a6018a1d51a394692ebe45c11b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4906c6d01ea4dc417f249425150e635a652630a6018a1d51a394692ebe45c11b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd76286d9c829da92bf2932a1e1974c0f15014bab0d9b01c70d4b6bd61f33812"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd76286d9c829da92bf2932a1e1974c0f15014bab0d9b01c70d4b6bd61f33812"
    sha256 cellar: :any_skip_relocation, catalina:       "bd76286d9c829da92bf2932a1e1974c0f15014bab0d9b01c70d4b6bd61f33812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e2d754abaf219684b5de4f223c3245d14c4d9771ece7be78ead65815b2ef825"
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
