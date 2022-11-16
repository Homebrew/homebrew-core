class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.50.tar.xz"
  sha256 "6e6c20d0778339069d583c0d63759d297e817ea10d0d897ebbe965f16e2e8e52"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-only"]

  bottle do
    sha256 arm64_ventura:  "a9499ac50e2f6e22c1c41839e30c9ee35b8d26283a3d6bea9245d07733d36218"
    sha256 arm64_monterey: "5c2386595e059d1cead2c6faf9b57544ff41d9b306e2ad60f2be57157256b966"
    sha256 arm64_big_sur:  "6ed258aa2e65be0a98bd5778d88883533f4814d74a4d8311b1875184ff3c5ed1"
    sha256 ventura:        "0bb1ba7f9cac855d5a01d1074acb15d84ef46ce94f6ae69789209a04cae6caf4"
    sha256 monterey:       "d405f26c28d748604664dbed110bbbe520a9fb10c109a06b3fbaf8409b7ef6a0"
    sha256 big_sur:        "3f7214b79d4035c79a3b505d78e65e15fd55a14a5eecce4efb5e078af3afc2a1"
    sha256 catalina:       "79404074c9a4ac0af485e76375b60cfc8fd5c03f10fc42bc7c517be717a5b33c"
    sha256 x86_64_linux:   "f601eba91c5184233aa5ad6b43776453f6b183484ded55280cfafd9350cb214e"
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
