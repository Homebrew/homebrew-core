class Amp < Formula
  desc "Text editor for your terminal"
  homepage "https://amp.rs"
  url "https://github.com/jmacdonald/amp/archive/0.6.2.tar.gz"
  sha256 "9279efcecdb743b8987fbedf281f569d84eaf42a0eee556c3447f3dc9c9dfe3b"
  head "https://github.com/jmacdonald/amp.git"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "libiconv"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
