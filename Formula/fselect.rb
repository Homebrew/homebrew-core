class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.5.tar.gz"
  sha256 "d08e6f34b52f87604b575daba7a48a8803181f5605fa689e4f4ebec0c4e96f2c"

  bottle do
    sha256 "a2ffc67b732c117931798264751a7197c231cdf171c8898f9d2fceeeaabb475f" => :mojave
    sha256 "7452c206252774dfd5f6f7fb6ae49b98b5a9424738c6c51dbbdcb2ca6f1bd91e" => :high_sierra
    sha256 "7ef9def834fa368a8039d42441a22b5fcd5b2dac2f2871a1c649e7ef662accbf" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
