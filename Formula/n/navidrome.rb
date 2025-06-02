class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "da93448b008f8611f1e1c203285361b5c05ab429253495341cc0bf08a5c93359"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a49cfc990ed805cc895926dc7df7af36efce32780175cb1a985d798f1628fda5"
    sha256 cellar: :any,                 arm64_sonoma:  "578d900a5b1840e3937cf5ccd627c0506f680447ae1307aabb8f7eef64a8ea83"
    sha256 cellar: :any,                 arm64_ventura: "9aadc7226d8169dc50d7af0787722ce02da99e047479b4b783153d9565f170ae"
    sha256 cellar: :any,                 sonoma:        "7f8d51c76c9fa2d13c1ecef6ffb79964c95a10279b10ade491d5ec9e8864a575"
    sha256 cellar: :any,                 ventura:       "aa9ccbf12f07cafe33e80a16808a5c4322dd81fbc8679b373f7be995b45daee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09c5ffa61f4ea39614d47fae32dc525946404ac5e3b483f87c4c0345d688e0f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
