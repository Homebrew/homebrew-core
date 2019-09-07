class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 3

  bottle do
    sha256 "eb50b0e19db7f772ed264f5a52b1eb786b7680c921e2fb9495fd8aa584a8bc42" => :mojave
    sha256 "de90d5978eb6185b5b44ecf9b99ae5063ebeef6e2557e2dec2bc65f7ecc124c8" => :high_sierra
    sha256 "d437b3b8338a57b6717b249e99f65de1e001b48642d525fe41e511babfceee91" => :sierra
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
