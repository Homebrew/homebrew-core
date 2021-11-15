class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.38.0",
      revision: "143750901ee320506f5083691990f61f1e7d93d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30fb51a48235fc0c4248de378f893ccbc5773b4ecc23e43eeafe8bc8f94121b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30fb51a48235fc0c4248de378f893ccbc5773b4ecc23e43eeafe8bc8f94121b6"
    sha256 cellar: :any_skip_relocation, monterey:       "b9919a54bb73f487774748f3a63b9c67d8f1dccaaca3a796eea1591744cd5498"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9919a54bb73f487774748f3a63b9c67d8f1dccaaca3a796eea1591744cd5498"
    sha256 cellar: :any_skip_relocation, catalina:       "b9919a54bb73f487774748f3a63b9c67d8f1dccaaca3a796eea1591744cd5498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc764b05e9a8cac8e2a09a19115b1f9a5bea6afe2e7c503f5471bbacac00a9b"
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
