class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 1

  bottle do
    sha256 "d9371f2d04b92210424659a9185566934e61206f8826c6eea2dc5369116edb0a" => :mojave
    sha256 "b7331b0651601ea935ddef51696331f40fcbec6ccfdf47ec6e098c3eb2c5a6ed" => :high_sierra
    sha256 "1f32f36d11ba90faa6832dab41161f64899ad18a03fcdb86db9e2e9279e13048" => :sierra
    sha256 "4a60f91551cbb90ef63e95ea11b377afcd2a21a1b3ae9a81f6dd98aee043036d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  needs :cxx11

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
