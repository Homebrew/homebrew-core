class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.46.1",
      revision: "595aba5a9beaa61df8a226da3a0400118bd32c50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a6a73021697604db6ea9d31ad33c0ed43283b6846472acb9ad0783b953dab36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a6a73021697604db6ea9d31ad33c0ed43283b6846472acb9ad0783b953dab36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a6a73021697604db6ea9d31ad33c0ed43283b6846472acb9ad0783b953dab36"
    sha256 cellar: :any_skip_relocation, ventura:        "4c47964085a6faf35252a2b89ef6044de5d60ff77f77055eb7bd103f797bf319"
    sha256 cellar: :any_skip_relocation, monterey:       "4c47964085a6faf35252a2b89ef6044de5d60ff77f77055eb7bd103f797bf319"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c47964085a6faf35252a2b89ef6044de5d60ff77f77055eb7bd103f797bf319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e7a662e07fc63bb43789055cb15453729b7c267d311928bee675c052ec87c6"
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
