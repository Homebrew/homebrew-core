class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.2.tar.xz"
  sha256 "39a718cdb64ea45225a7e94f88dddec1869ab37a21b339ad058a9d898782c00d"

  bottle do
    sha256 "59fcc7da30bf5df62481f5a469bfa2cbcd652b6e433efed593d966c32e2bbd48" => :sierra
    sha256 "8b453f9b6f993a5e160266768b5fbdde47cdc5c21a3ab0474ff7c0992f1e762b" => :el_capitan
    sha256 "0375322c23427755b7a3c2ca43778c6d1da2792a109cc0c9a58806078214440d" => :yosemite
    sha256 "732b19cd457e124d4a89d6ddd6a6ed7ed8d14da2586d9a6908ccc95ad3bbaa9b" => :mavericks
  end

  head do
    url "https://git.gnome.org/browse/cogl.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk-doc"
  depends_on "pango"

  # Lion's grep fails, which later results in compilation failures:
  # libtool: link: /usr/bin/grep -E -e [really long regexp] ".libs/libcogl.exp" > ".libs/libcogl.expT"
  # grep: Regular expression too big
  if MacOS.version == :lion
    resource "grep" do
      url "https://ftpmirror.gnu.org/grep/grep-2.20.tar.xz"
      mirror "https://ftp.gnu.org/gnu/grep/grep-2.20.tar.xz"
      sha256 "f0af452bc0d09464b6d089b6d56a0a3c16672e9ed9118fbe37b0b6aeaf069a65"
    end
  end

  def install
    # Don't dump files in $HOME.
    ENV["GI_SCANNER_DISABLE_CACHE"] = "yes"

    if MacOS.version == :lion
      resource("grep").stage do
        system "./configure", "--disable-dependency-tracking",
               "--disable-nls",
               "--prefix=#{buildpath}/grep"
        system "make", "install"
        ENV["GREP"] = "#{buildpath}/grep/bin/grep"
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-cogl-pango=yes
      --enable-introspection=yes
      --disable-glx
      --without-x
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
    doc.install "examples"
  end
  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <cogl/cogl.h>

      int main()
      {
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/cogl",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
