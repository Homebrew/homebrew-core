class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.54.4.tar.gz"
  sha256 "30a325ce285ed53f6f7722b2be45a4094b0398ff0ffcda2912dda062184a3b44"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "504ed8c3bdc1b59bc43619a78a47339992346b314ba89b360ad323b8eeebbf7a"
    sha256 cellar: :any,                 arm64_sonoma:  "c707f80bb2dd18867c9bd44ae356b85ed0785bebf98cf5200c57c1f147336b56"
    sha256 cellar: :any,                 arm64_ventura: "91d72755a2f65ec2789077821277e1d40da51a5569c71c490898b6435b62d033"
    sha256 cellar: :any,                 sonoma:        "d78ab9f5b33c1d2aa5941f6d3f6fc3c1e8a557038eadece737b9ae30cba4f781"
    sha256 cellar: :any,                 ventura:       "664ebbe10d1a84f6e78077eee1b77072a3b16f1d228473ce63428f529938a2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a23a4fdd56bb8d0f4d36fc7b7796388254ee615646b0b6bbc64c69f61495848"
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
