class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.6.2.tar.gz"
  sha256 "9279efcecdb743b8987fbedf281f569d84eaf42a0eee556c3447f3dc9c9dfe3b"
  license "GPL-3.0"
  head "https://github.com/jmacdonald/amp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01ab2e28990824907fdeed4ac093f2f42a9719c21cbc0ebe655406b77a24b44e" => :big_sur
    sha256 "6d91e4902ead60e50e7dd5b7faed62a4f41999433b321e2b48682d8e8f057f2c" => :catalina
    sha256 "59f96770d9e4e166c6eabfb359ada98c41edece8b2fbb877b4e855977445aaa2" => :mojave
    sha256 "96ed5e0a0ba3d05358c840ee0ca157d75ca5f4613fc0e152465806d9950bfa9e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "libiconv"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, _, wait_thr = Open3.popen2 "script -q /dev/null"
    input.puts "stty rows 80 cols 43 && #{bin}/amp test.txt"
    sleep 1
    # switch to insert mode and add data
    input.putc "i"
    sleep 1
    input.puts "test data"
    # escape to normal mode, save the file, and quit
    input.putc "\e"
    sleep 1
    input.putc "s"
    sleep 1
    input.putc "Q"

    assert_match "test data\n", (testpath/"test.txt").read
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
