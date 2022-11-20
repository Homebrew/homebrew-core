class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.45.0",
      revision: "a301046f3dd728ef088843680b7fd13800ff1ba0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ec9c5d0982aafbc70394d5d673a3586686d2e3b2315f4a382b020afaee1ecfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "362d0f63ad897a582dc683485d75c5e59e7f2dcd8024538a05333b9ca99318b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "362d0f63ad897a582dc683485d75c5e59e7f2dcd8024538a05333b9ca99318b2"
    sha256 cellar: :any_skip_relocation, ventura:        "f9797d0dda4be4c32579d113b0b0aea281ecc2983cab448c4711ff9e0e1ecae8"
    sha256 cellar: :any_skip_relocation, monterey:       "ce9745278a5cd000c39129f20e7b540f13365a03f94fe02ea2d2c697b99e43ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce9745278a5cd000c39129f20e7b540f13365a03f94fe02ea2d2c697b99e43ab"
    sha256 cellar: :any_skip_relocation, catalina:       "ce9745278a5cd000c39129f20e7b540f13365a03f94fe02ea2d2c697b99e43ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1585663a56d2e77e0fabdd40566f56a20d90e41dea45301c082693e383fda8d"
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
