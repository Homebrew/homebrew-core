class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.42.0",
      revision: "eb1e19a8212061e56a43ce798a231cd64cce989d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a81991278a1f027dc90898eeb39cd591cfb17f5af422847b141b2ca43beeb14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a81991278a1f027dc90898eeb39cd591cfb17f5af422847b141b2ca43beeb14"
    sha256 cellar: :any_skip_relocation, monterey:       "248cd6a192017a7f38afb9b1f9dfcc3fa42e2f9587ba05a337d6b7f4805a59c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "248cd6a192017a7f38afb9b1f9dfcc3fa42e2f9587ba05a337d6b7f4805a59c0"
    sha256 cellar: :any_skip_relocation, catalina:       "248cd6a192017a7f38afb9b1f9dfcc3fa42e2f9587ba05a337d6b7f4805a59c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e4a0eb7135cbbedaf480b61c687614ace0c13b61de00f9bd1bec2726800398"
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
