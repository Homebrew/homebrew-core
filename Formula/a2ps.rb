class A2ps < Formula
  desc "Any-to-PostScript filter"
  homepage "https://www.gnu.org/software/a2ps/"
  url "https://ftp.gnu.org/gnu/a2ps/a2ps-4.15.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/a2ps/a2ps-4.15.4.tar.gz"
  sha256 "4a063f84ba89d86be14a6704ca35fd130083b572f1376b439a1b79b67b206dd7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "0ea1d924e3cafdeec54cad07a7e6943a22c34adc2def0629577ef0dbe38b25f6"
    sha256 arm64_monterey: "198ae0777464281b2c558eed465fd564b1bf5b58a95541eb4a61a816a1ddaa53"
    sha256 arm64_big_sur:  "33f9faf14ebd9458592c74b51396e179deebb759f675d3f0db5a5bfb8e042c60"
    sha256 ventura:        "160286dc93e7de40007efd710c045b1f5f512fdeb2920a2ac5f04d8e7095fe5d"
    sha256 monterey:       "792a2655206a0a473ef14da7c45a22ecde0c3bafbdb1b79431ad427e4798aab0"
    sha256 big_sur:        "48a9535dca94ea934d519890e00619e6e87803d1ae1912e0a8ead548db1253d7"
    sha256 x86_64_linux:   "b90bd57ecf4541afdd19b09fdbf186d850dbcbc4d4a3037fb7e7784029623fec"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "libpaper"
  uses_from_macos "gperf"

  def install
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--with-lispdir=#{elisp}",
                          "--with-packager=#{tap.user}",
                          "--with-packager-version=#{pkg_version}",
                          "--with-packager-bug-reports=#{tap.issues_url}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("")
  end
end
