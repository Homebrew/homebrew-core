class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.48.0",
      revision: "8fb99ef7a99c7a87065247d60be4a08218afa60b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c83cd29b90e5837f00e150a9896948282332d73837a47a63e558854fab6624e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83cd29b90e5837f00e150a9896948282332d73837a47a63e558854fab6624e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c83cd29b90e5837f00e150a9896948282332d73837a47a63e558854fab6624e4"
    sha256 cellar: :any_skip_relocation, ventura:        "2866a1452edbadfd2f896dd0219310a7183e4064d5e04acd5f69ca56c112f597"
    sha256 cellar: :any_skip_relocation, monterey:       "2866a1452edbadfd2f896dd0219310a7183e4064d5e04acd5f69ca56c112f597"
    sha256 cellar: :any_skip_relocation, big_sur:        "2866a1452edbadfd2f896dd0219310a7183e4064d5e04acd5f69ca56c112f597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1c6596e921f7b6bc6446ceeca43b49ac63037af8cb0bb74fd13114741378b6"
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
