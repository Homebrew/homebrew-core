class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.55.tar.xz"
  sha256 "74d60abba15bd3ea5ad17da5b924d8e36f649a25c3dc77adbabd2a3628a02131"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_tahoe:   "a9493cdffa72b2416a94d0652a33114b46b84f980a826f2498ede178a13f2f35"
    sha256 arm64_sequoia: "b38fc2e609bfede820912b20981be32f4b2f1f1a5cf611b6d86ef669da5e6f13"
    sha256 arm64_sonoma:  "7403bf4a01064a3f27ed7a565fc704454261368e45954c15a42fd35b14ed9bb6"
    sha256 sonoma:        "0bc620a92e8217401152938b301be407b34af8777aff52b3878107f729d3b517"
    sha256 arm64_linux:   "ed0ed9d3d77838c08b4cf98f920c16eb3ebea97a19f9ba109be5b1e6dfc04487"
    sha256 x86_64_linux:  "972749d47f4077fe959f6160bd91696efc9e4f9bc349abd717e94f68b659adf1"
  end

  head do
    url "https://github.com/GNOME/libgsf.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~C
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
