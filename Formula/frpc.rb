class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.46.1",
      revision: "595aba5a9beaa61df8a226da3a0400118bd32c50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06fc779cc08b319c3eb3534a19e7cc0da5e632ffd61efa10b6661de2d8f44b45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06fc779cc08b319c3eb3534a19e7cc0da5e632ffd61efa10b6661de2d8f44b45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06fc779cc08b319c3eb3534a19e7cc0da5e632ffd61efa10b6661de2d8f44b45"
    sha256 cellar: :any_skip_relocation, ventura:        "412ebde5cdae0bfcc1a93345fc49075e78553de9b18a41dfaa4b2da8b42e836f"
    sha256 cellar: :any_skip_relocation, monterey:       "412ebde5cdae0bfcc1a93345fc49075e78553de9b18a41dfaa4b2da8b42e836f"
    sha256 cellar: :any_skip_relocation, big_sur:        "412ebde5cdae0bfcc1a93345fc49075e78553de9b18a41dfaa4b2da8b42e836f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa24edd9f7b61a27b42204a7bab3ad545355b7aae148071a6c51ba28bea36efd"
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
