class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.7.tar.gz"
  sha256 "4d65f368b2d53ee2f93a25d5e9541ce27357f2b95e5e5afff210e0805042811e"
  revision 1
  head "https://github.com/wolfcw/libfaketime.git"

  bottle do
    sha256 "b0407a1063d15d262b5c204fa9b8275c050a3e9041f059bbfd3bf478358959db" => :high_sierra
    sha256 "cc615ac1fb6806cd182074d765c971ad173b97fee1d1a78ba0ad0123ca8ad4d9" => :sierra
    sha256 "d9b8d66be340ea8ee970adb669a6848bc9c1dbe94ed48b5bb36c1212e42dc801" => :el_capitan
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
    assert_match "1230106542", shell_output(%Q(TZ=UTC #{bin}/faketime -f "2008-12-24 08:15:42" #{testpath}/date +%s)).strip
  end
end
