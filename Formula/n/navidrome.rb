class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "4eeeadb7cdf527cb8ccccc1522c1bf3f0f391f9fcf04dee5eeaf7896c4871207"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eef9a7160c39470200421a8a0591b0f119f22ab79dd83d3dc79a5eebe651be8b"
    sha256 cellar: :any,                 arm64_sonoma:  "3c85c2753d06fb622a395e2939cd528b88b875e266ce3ad431b062be30e29267"
    sha256 cellar: :any,                 arm64_ventura: "859224f3e449e8f3a2adba2f6dd443554e842d3529282b64c6ccb09a5e5f0821"
    sha256 cellar: :any,                 sonoma:        "6b2944841b3074e0ecee99f30d6215d4a11842185b972322cbc74de0e33ea43c"
    sha256 cellar: :any,                 ventura:       "8e16fa28d91542e417dff3b5c3ea9f9f8b59739c896f95f7fc5fe43f47ebe400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4a79b9c6ffe3968de2275ec352192c2220794654e7de29eceb99f86a006fef"
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
