class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.4.3.tar.gz"
  sha256 "712145c83fe3989c6b54fda685403db09fce0be8dc6a2567bc895fd6d7674d7e"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de4c6ca2037cfc860687c5da09de06ff4dc2a7939b3409fb1b7f04b0fa0fa216"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1f0f05d876e139fd3c962f7fbc1f2a94fbdbe1f360eea27e17316cab39ca302"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b179e21cb562842bbe4262cb856789ac344f10873da338ef90fd9e2131d8ab46"
    sha256 cellar: :any_skip_relocation, sonoma:         "90cae569cbd52f7168855a829474426eb44a458bd5a0fa81ea58e141f24c7225"
    sha256 cellar: :any_skip_relocation, ventura:        "760275a65b1af2fd6e706b8c586d43ab5dd7e3ba81177d6111dd64f02c3ff4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4edab2d79c1f2280164247f6bc816f430b0c660d57e6b498f1cfc3d6379027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0c294d26e005ab61f3c0bc283f95eef5824e95da8787ea3b7f80b315057f81"
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
