class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.9.tar.gz"
  sha256 "57d0181150361c0a9b5c8eef05b11392f6134ada2c2d998e92e63daed639647c"
  license "GPL-2.0-only"
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    sha256 big_sur:  "cf7b4559e89a7ea8049e9cfef460f7cf1f6e9403f743562e26010d4ef2705454"
    sha256 catalina: "b5e7ab51f854c78569b3bd6b52f3a668cf2b99e38fb5324f6a195c073f62f950"
    sha256 mojave:   "e35274e338e72a603ed6b338437d09fc58427b65077a09e0159514e4df249317"
  end

  # The `faketime` command needs GNU `gdate` not BSD `date`.
  # See https://github.com/wolfcw/libfaketime/issues/158 and
  # https://github.com/Homebrew/homebrew-core/issues/26568
  depends_on "coreutils"

  depends_on macos: :sierra

  def install
    system "make", "-C", "src", "-f", "Makefile.OSX", "PREFIX=#{prefix}"
    bin.install "src/faketime"
    (lib/"faketime").install "src/libfaketime.1.dylib"
    man1.install "man/faketime.1"
  end

  test do
    cp "/bin/date", testpath/"date" # Work around SIP.
    assert_match "1230106542",
      shell_output(%Q(TZ=UTC #{bin}/faketime -f "2008-12-24 08:15:42" #{testpath}/date +%s)).strip
  end
end
