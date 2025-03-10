class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.54.5.tar.gz"
  sha256 "38d20258b418a33ffbb8b36db9a82c4efc49edf434de4f4e36e2ec7d01010f77"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6ee9356037c8afa1e79f7c31897ef195ef13559b85c2f9151a44e4607edf15b"
    sha256 cellar: :any,                 arm64_sonoma:  "3fa20ed39d2c7b8de69774a11f4746f4ea4e05d55344bb79d85ae923334a0e26"
    sha256 cellar: :any,                 arm64_ventura: "b0c2b2431f1097a40bc6bc8c656e8a8cc0f0d42d80c81a528961ae05bf942011"
    sha256 cellar: :any,                 sonoma:        "b2c2a235b21eedbbedb0f180c89fda33dd7feea07f144451854bd9239f3a740f"
    sha256 cellar: :any,                 ventura:       "8594f5a76c5e65a9b3e51a9b266f7605c8a1442a69f9c58a78527f6e6b1b4fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33892f28f1a6d46da00ccdfb7f32ae97a2be5cff8f7771efecd7aa71a501b583"
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
    system "go", "build", *std_go_args(ldflags:), "-buildvcs=false", "-tags=netgo"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 60 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
