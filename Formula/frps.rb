class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.45.0",
      revision: "a301046f3dd728ef088843680b7fd13800ff1ba0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d819ef8a09a39acd26cdd85d83069a7b13097736c152a16f454ccd91ce992041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "312891500bba7909461d27c1de0631f93eaba6f9018aab8430f67dd22dbd027a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "312891500bba7909461d27c1de0631f93eaba6f9018aab8430f67dd22dbd027a"
    sha256 cellar: :any_skip_relocation, ventura:        "ca431a070e967a173bc4a51c5b7893aee779ec7603f22fad24695d9146c59318"
    sha256 cellar: :any_skip_relocation, monterey:       "811e8c154895e3f3d3fe795b16c2260f0f189080f28a1dbb54d5f2f3b77cf990"
    sha256 cellar: :any_skip_relocation, big_sur:        "811e8c154895e3f3d3fe795b16c2260f0f189080f28a1dbb54d5f2f3b77cf990"
    sha256 cellar: :any_skip_relocation, catalina:       "811e8c154895e3f3d3fe795b16c2260f0f189080f28a1dbb54d5f2f3b77cf990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995b4f8324a602002a993576773088328ad60f1862f0677efe618189f391ebc5"
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
