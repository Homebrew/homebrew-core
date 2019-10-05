class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 4

  bottle do
    sha256 "556220452f97694f3645f359d2dec863134dfcfb4295143fc96752c26a5fcb17" => :catalina
    sha256 "69c420e26e619dd25f064703cf27058dee4a55df67240576b599444041baebc8" => :mojave
    sha256 "5a1c7102e0fd7cfb20d2dc895ce82a24117fe8137f47ec357fa5df6ec14d1ee0" => :high_sierra
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
