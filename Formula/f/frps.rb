class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.3",
      revision: "466d69eae08e44f118302cf433d3f4d6e8d04893"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "926388f26c0cce1fb0f4f655e657b2e33550d9695d211e7c2859af5768c81766"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926388f26c0cce1fb0f4f655e657b2e33550d9695d211e7c2859af5768c81766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "926388f26c0cce1fb0f4f655e657b2e33550d9695d211e7c2859af5768c81766"
    sha256 cellar: :any_skip_relocation, ventura:        "eb5ae712cd48c690662c3d683db59431913b1354188d980eb03dbace76571c44"
    sha256 cellar: :any_skip_relocation, monterey:       "eb5ae712cd48c690662c3d683db59431913b1354188d980eb03dbace76571c44"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb5ae712cd48c690662c3d683db59431913b1354188d980eb03dbace76571c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d682164402481beda22d24f326b16d2d33681788d8452480ddf6215893da2fdf"
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
