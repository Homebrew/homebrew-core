class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.43.0",
      revision: "fe5fb0326b2aa7741d5b5d8f8c4c3ca12bb4ed91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daade03620d283833a8557dac4e8a894e24ab42664782216910dbbec9dc422fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daade03620d283833a8557dac4e8a894e24ab42664782216910dbbec9dc422fc"
    sha256 cellar: :any_skip_relocation, monterey:       "6bc3baea146f12b33a794c8a02b52e77e5d325df70d389de071cbd5b16a777c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bc3baea146f12b33a794c8a02b52e77e5d325df70d389de071cbd5b16a777c2"
    sha256 cellar: :any_skip_relocation, catalina:       "6bc3baea146f12b33a794c8a02b52e77e5d325df70d389de071cbd5b16a777c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6bb86c9fa43fc44639adfb41edb23c40babe55f2b1e4f5060f3e9fe2a662745"
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
