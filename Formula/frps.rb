class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.49.0",
      revision: "0d6d968fe8b58a36903bfe2c60a0ce8c218a63ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2e8c2adf67aceda2480db6616871bfa8854f81369a99a172dde3621f6ff1ecc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2e8c2adf67aceda2480db6616871bfa8854f81369a99a172dde3621f6ff1ecc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2e8c2adf67aceda2480db6616871bfa8854f81369a99a172dde3621f6ff1ecc"
    sha256 cellar: :any_skip_relocation, ventura:        "2d4f4d31fe1f488edb7d3701d8d1c7a212c55b6b97e2c1939b1b317d224e9dad"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4f4d31fe1f488edb7d3701d8d1c7a212c55b6b97e2c1939b1b317d224e9dad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d4f4d31fe1f488edb7d3701d8d1c7a212c55b6b97e2c1939b1b317d224e9dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fda3a7d7962bf92478ce4a29c349af152491935c3ad89505e78af378762a217"
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
