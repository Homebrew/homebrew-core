class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.40.0",
      revision: "ce677820c6d8dbcfebf9f3a581453192a95f91e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0706ecb32876d1bda4953d168103fcb097b215252bdbbf7e6008120f6cdcef02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0706ecb32876d1bda4953d168103fcb097b215252bdbbf7e6008120f6cdcef02"
    sha256 cellar: :any_skip_relocation, monterey:       "1114e22114b3babc12f1f144289ddbcd1a598853cc587f10c01264cd81c8b191"
    sha256 cellar: :any_skip_relocation, big_sur:        "1114e22114b3babc12f1f144289ddbcd1a598853cc587f10c01264cd81c8b191"
    sha256 cellar: :any_skip_relocation, catalina:       "1114e22114b3babc12f1f144289ddbcd1a598853cc587f10c01264cd81c8b191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a77fa718a3baa01cafb1e8254f6344c978a410f7c1c008debed553d0c926f869"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
