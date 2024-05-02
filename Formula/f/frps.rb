class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.57.0",
      revision: "8f23733f478a9962d3ad4d8e1d8c01dafdb4d49d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0508d89d4dad08772253f283ff5982b86eb10dbee5bcb92a7bba9fdb31e49880"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0508d89d4dad08772253f283ff5982b86eb10dbee5bcb92a7bba9fdb31e49880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0508d89d4dad08772253f283ff5982b86eb10dbee5bcb92a7bba9fdb31e49880"
    sha256 cellar: :any_skip_relocation, sonoma:         "a18405d9b99eaef2f02d110b6ad0c9c039a665bc4fe4a04239b014360498651c"
    sha256 cellar: :any_skip_relocation, ventura:        "a18405d9b99eaef2f02d110b6ad0c9c039a665bc4fe4a04239b014360498651c"
    sha256 cellar: :any_skip_relocation, monterey:       "a18405d9b99eaef2f02d110b6ad0c9c039a665bc4fe4a04239b014360498651c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b11027a4c05560a01334a834013314c83be022c75b156721f05103c763559cd"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.toml" => "frp/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
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
