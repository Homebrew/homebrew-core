class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "9fa61b31fa6b6eeb3ccc018d806b9e672bb66d63c581f15ba8f409f32bca7742"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed27bcf65cfc7f66062e2f7d33018a5bfd198689eb62823b1908e21c055fb624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43259fbb7b8dee0dce6bfe04fda0f5f488088311482e5b9d52c780d458764cca"
    sha256 cellar: :any_skip_relocation, monterey:       "b6751af4f91d45240d2b36d5a641f846b18b396d772d2c63c741d9e7139042c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3feb8a7edfcccebf8c335a65863a254e0e7bcb9e0410f51be5166e1f7553e8f2"
    sha256 cellar: :any_skip_relocation, catalina:       "1d4d34b49f9b14e50db7f542e88e31751a95a3b451a0f927d19ff59ab86380c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a436e81e66fe6288b70ddf06fe406663df550db5b88edeeb4ea946161f5850b9"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
