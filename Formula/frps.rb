class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.44.0",
      revision: "8888610d8339bb26bbfe788d4e8edfd6b3dc9ad6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeb73381582885d04627de7b7df375e2b2244b314a501646ef5ad8b2a3895cfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeb73381582885d04627de7b7df375e2b2244b314a501646ef5ad8b2a3895cfa"
    sha256 cellar: :any_skip_relocation, monterey:       "fe85f148dbb91564a5885b4408bbde002e464213b2b9d55f8bb764930674396e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe85f148dbb91564a5885b4408bbde002e464213b2b9d55f8bb764930674396e"
    sha256 cellar: :any_skip_relocation, catalina:       "fe85f148dbb91564a5885b4408bbde002e464213b2b9d55f8bb764930674396e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a05ef4af1ab2ad73b0e24033ec9d2da2ba948377ba912d9bd6808929c6aeb0"
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
