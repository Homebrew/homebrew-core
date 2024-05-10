class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.52.tar.xz"
  sha256 "9181c914b9fac0e05d6bcaa34c7b552fe5fc0961d3c9f8c01ccc381fb084bcf0"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_sonoma:   "f57e82c2967d687328a10ab88c8316cf7ee315df438f45cf8783300c6a850024"
    sha256 arm64_ventura:  "cfd187b4a37a683fecead4d876c6ddee733b6cfa2c2d693669f643146909c2a7"
    sha256 arm64_monterey: "444717a56a10de924edf4b0c1011ef817fdce2792b60ddb7ab8b737a004bdcfe"
    sha256 sonoma:         "0694ed2751960fed7e4b2600638c03bef76c5df2a984e9a6a4dff21990da6457"
    sha256 ventura:        "ac6805d35cdacf2d2c58e84994e7ee4819ec6d63bbe2b2d57de948b250408ec7"
    sha256 monterey:       "9354391263dac31467977f4ae0e08de9979fc5ff6845601a06b97198dfa8ac86"
    sha256 x86_64_linux:   "831615975bae111b9a88f8f59ce99a80953a3ca72f7c655ab29ffa2fafc6c1df"
  end

  head do
    url "https://github.com/GNOME/libgsf.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args, "--disable-silent-rules"
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
