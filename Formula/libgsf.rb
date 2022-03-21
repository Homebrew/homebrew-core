class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.49.tar.xz"
  sha256 "e9ebe36688f010c9e6e40c8903f3732948deb8aca032578d07d0751bd82cf857"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_monterey: "b4f7cf3af8caa8b37b04297651f835ad4817f2eadd801053929701b89a5a20aa"
    sha256 arm64_big_sur:  "09eec762124167dbba66e3c9f66eb6720ddb99f93f720da78161a57adda6bbf8"
    sha256 monterey:       "5e179d8367799493a823c13dddcd960f6a94335b61190531c6830b0d7139259e"
    sha256 big_sur:        "6256f65f5cfbc1f5a7ac01713c36490c6bb7be1ca779b1f30a076850a6091821"
    sha256 catalina:       "4bbd87e330bcbadd98b49655fffc7e4ab18e27c6015cd295a2fca378ac5575a7"
    sha256 x86_64_linux:   "d9ffdb9168375f025302a615f3976954eb297cdc17784aa4a665e0f7c09f0a51"
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "libxml2"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~EOS
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
