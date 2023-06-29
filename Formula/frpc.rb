class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.50.0",
      revision: "4fd800bc48708843e32962c9ce23df6f971fdc99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c47572f9bee74f80ba5b1cba9b177d5329f6edf1d446057fa7636060e77b0468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47572f9bee74f80ba5b1cba9b177d5329f6edf1d446057fa7636060e77b0468"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c47572f9bee74f80ba5b1cba9b177d5329f6edf1d446057fa7636060e77b0468"
    sha256 cellar: :any_skip_relocation, ventura:        "3de046fadf03ea397177d937697fed756b42e01402c08fa181fed2a5f8d83162"
    sha256 cellar: :any_skip_relocation, monterey:       "3de046fadf03ea397177d937697fed756b42e01402c08fa181fed2a5f8d83162"
    sha256 cellar: :any_skip_relocation, big_sur:        "3de046fadf03ea397177d937697fed756b42e01402c08fa181fed2a5f8d83162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092c8701ba72118631b5079b87d3bc514cc6f70acf39dc0a0cfdb191662c2d77"
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
