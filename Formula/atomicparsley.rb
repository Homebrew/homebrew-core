class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20200701.154658.b0d6223.tar.gz"
  version "20200701.154658.b0d6223"
  sha256 "52f11dc0cbd8964fcdaf019bfada2102f9ee716a1d480cd43ae5925b4361c834"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "632b3bc281a6f3bd5b9a913dff1e805c9fb9997f41b4a02db0a1aa34f6faced3" => :catalina
    sha256 "d32a565f675bd0b2c5ebf1b5aee01fb79d9d42b072dedf724b7ee03b2cc242ee" => :mojave
    sha256 "05c4cdc1dfc14fa6f06fdbbcadead5055a9fb53091d014458b86ecb4b22111fe" => :high_sierra
    sha256 "d5f8672d420511ff76fd9ecc4d41c8aee5eecbf4382d7c4bd3fb04400c4617f4" => :sierra
    sha256 "c0a7964ced998b2db7150f95b9329e138f28f0768be50d531fd4d82754e0ebde" => :el_capitan
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
