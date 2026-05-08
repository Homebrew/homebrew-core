class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.58.tar.xz"
  sha256 "06e07ea12b7a52b9e316faddfecb640b1717a4875c59f0efb3b0cec1e2ccf35a"
  license "LGPL-2.1-only"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "6e66446753a7dce2b9b4ae00e171fff897f6f4f6ac96da1ef721c630b5c925f1"
    sha256 arm64_sequoia: "59f3fb38666b431b35203df8ff18fb48182a316a4408c6fe26738c88f9989f16"
    sha256 arm64_sonoma:  "77fa3f31ce95b4396251273efb748f26dc36f337d776c91cc7d93673be9f5077"
    sha256 sonoma:        "82ac416b21076164a9f0b3a6fdcb5642e8e6a5460f5ad70588fc464b55b67e1e"
    sha256 arm64_linux:   "d393e0095b5f024656a724fd4cd707f93e182686cb6120f4b75bf6d7c6c50600"
    sha256 x86_64_linux:  "caf57cae32526d2adc90044a7c5778723d417dc0676d7406335b4d3502b404a7"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
