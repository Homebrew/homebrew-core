class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "https://github.com/davep/eg"
  url "https://github.com/davep/eg/archive/v1.02.tar.gz"
  sha256 "6b73fff51b5cf82e94cdd60f295a8f80e7bbb059891d4c75d5b1a6f0c5cc7003"
  head "https://github.com/davep/eg.git"

  bottle do
    sha256 "d48319623e66719275970f0f2c40ded729720e134b5e93b9ff3e871ee0903807" => :mojave
    sha256 "4955ef20bd0d41b433f077784ca1a9d96a40eb2e6f7840c70f308b60d1fc553d" => :high_sierra
    sha256 "307a0ce0f1514288179dbbc56fdac3de02100c80e8c57b1abedcab5cd0cff458" => :sierra
    sha256 "500a97f229b78ab83b97591d9276f7d9e1e4ce4d392f2530f5c8a9f10543b469" => :el_capitan
    sha256 "65d2bab2a43912dfd487f817724dc7feee3ba3e226c07d0bd78ad22edcea970c" => :yosemite
  end

  depends_on "s-lang"

  def install
    inreplace "eglib.c", "/usr/share/", "#{etc}/"
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}", "NGDIR=#{etc}/norton-guides"
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success if the file doesn't
    # exist, without popping into the UI - we're exploiting this here.
    ENV["TERM"] = "xterm"
    system bin/"eg", "not_here.ng"
  end
end
