class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.6.6.tar.gz"
  sha256 "1142d07846ccf5e9f12cada485da949783ab83076af2af6c62b1606df5b55d9a"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d0205d6e8435c790237aa80cddef085db773a79a5c6c980aa093c8c75ecbfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d0cfa5f318087b4acd5b18637b234b5e76e81a072a717435f97e8edd8d7974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "478dfeb579c7a33f383df4ae15a6637cdf197db9c88e33568e234fcd790fc97d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcedf375aedf8efc0e4bdde2975c29f41587fd9b57ffec2a2ecc44a20172dedc"
    sha256 cellar: :any_skip_relocation, ventura:       "894122123e9c770afd7f6f1a3b925054272d8f6ab41e1e8966165b1335f40933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c55ecf868883621bc84370298b8cfff8672b1a5b7cd952b56ffc268a8d8643"
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
