class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.41.0",
      revision: "10f26201316ff99b4cd6bd3fde9526e1c9c5a95a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b4add329b5de6892ea6e06a4eac759c08b14273a4e2aded43e29986ce9b642"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5b4add329b5de6892ea6e06a4eac759c08b14273a4e2aded43e29986ce9b642"
    sha256 cellar: :any_skip_relocation, monterey:       "7508360cdd72734c711e0823d2fe55a29801fb1548a31a630841ac18060bc5f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7508360cdd72734c711e0823d2fe55a29801fb1548a31a630841ac18060bc5f8"
    sha256 cellar: :any_skip_relocation, catalina:       "7508360cdd72734c711e0823d2fe55a29801fb1548a31a630841ac18060bc5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98b14d5d4cf9a1286c566f814407b67ccb597708f8c83d5c03241f4dba1f9c27"
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
