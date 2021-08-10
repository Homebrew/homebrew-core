class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 9

  bottle do
    sha256 arm64_big_sur: "692948e6fb9022e026c360b311288a71867d1281e83f5660f60413b6fd405941"
    sha256 big_sur:       "64de2b67064449818ce0cf15d7ba8330e9fe408359bc0b4a384f6cd0c5fb217d"
    sha256 catalina:      "8733d9d0433c4d316395ca033f9be5f20fe0506a7df92ac634077f0f204ad8cb"
    sha256 mojave:        "f68c2a19c127cd7fbcdffc8ef5202bcd80f8892e182efee2ba2e25ee04b173e6"
    sha256 x86_64_linux:  "43063bb647f4783d5ae54c6ebbaeba2864822b7ad40c77ec3c91067220c45bfb"
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
