class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7.tar.gz"
  sha256 "4d65f368b2d53ee2f93a25d5e9541ce27357f2b95e5e5afff210e0805042811e"
  revision 1
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    rebuild 1
    sha256 "74f8e3fb7f54bfdb8b2962dfde0428819b03772ee9138d39d30005c9c5c974d2" => :mojave
    sha256 "af523cc7dad3a5594fe1ff4fd8af3d8d21be0dff3c65bb309292d79233080795" => :high_sierra
    sha256 "e341fabbbfd9b0b9f2750b69c4926adf8116344b1a35fd655bd5e81b1c67d950" => :sierra
  end

  # The `faketime` command needs GNU `gdate` not BSD `date`.
  # See https://github.com/wolfcw/libfaketime/issues/158 and
  # https://github.com/Homebrew/homebrew-core/issues/26568
  depends_on "coreutils"

  depends_on :macos => :sierra

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
