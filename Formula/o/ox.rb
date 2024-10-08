class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.6.5.tar.gz"
  sha256 "410dc77ea2fcb9e73b8cba5121c3cf41215d4cf8cd219015d5f8e0caea4e42d7"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "060c52a419887a5520583a00299fe172783007003dc3f9e4f206e67f7333b883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e63eb5cdd11e15ea107d7060eb01cff1f2a829d73fdbbe4c197f3bfe770f5bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea147cd207bd3da17daf5b19398f91603774ef3199450166b4e1d67fa9a9e080"
    sha256 cellar: :any_skip_relocation, sonoma:        "80b1b95c00b08011eea01cf0cd5546f799cc1ca48e9873bef2d44d34a42cf106"
    sha256 cellar: :any_skip_relocation, ventura:       "09390d0c3f184fb08ff465948b4cf8290ec20fa71406ea7291a18b84951aa966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec39a83e22f3e51f64487ec676d0badf67a03b813aa2da915583971b5901731e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
