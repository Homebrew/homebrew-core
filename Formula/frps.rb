class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.37.1",
      revision: "997d406ec25832e7d16f140d110e4016f908d8cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95e52fbf7d0b92d0441a285f8af31c09ad043b0f5f788b891444382cb541f24e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e40eec889b4bc5beda2e2480a23df501a459f2dd48ea44889929317d026b52f3"
    sha256 cellar: :any_skip_relocation, catalina:      "e40eec889b4bc5beda2e2480a23df501a459f2dd48ea44889929317d026b52f3"
    sha256 cellar: :any_skip_relocation, mojave:        "e40eec889b4bc5beda2e2480a23df501a459f2dd48ea44889929317d026b52f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1063840c936f20f81652173f7f36d4fc28b87a4049dda6fa59e473bee39920e5"
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
