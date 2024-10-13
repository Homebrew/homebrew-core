class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/4.2/libxml++-4.2.0.tar.xz"
  sha256 "898accd9c6fa369da36bfebb5fee199d971b86d26187418796ba9238a6bd4842"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "313eb1af5b040a240c54769a0ea30007bb2ade22d25b0858a457922a37fa53f1"
    sha256 cellar: :any, arm64_sonoma:   "987e41fbe309acddde459a94d9ad151f8644cefee95be180366f3b774b3d6ff6"
    sha256 cellar: :any, arm64_ventura:  "35b445c5b312aa2a990ad57372c57f3c00d3b79d6247ac6007d5b00397467a9d"
    sha256 cellar: :any, arm64_monterey: "4d431e0cb82051dcf01c8e05d75c067ab5716852a61fc10f7d65655628c5c010"
    sha256 cellar: :any, sonoma:         "3784bffd82c84684b1c75fa7ea33adff114727fffebe2ccef5fcdb590c92c937"
    sha256 cellar: :any, ventura:        "bc1972685d7e69a840ebdb2c53b0596055ec1f5371c94508d02f04d9c70b5124"
    sha256 cellar: :any, monterey:       "1d4f0949c6e5caafd5e0d4476241bf827244bca988698aa9d78a8d03ad3e12c9"
    sha256               x86_64_linux:   "02e771bea9bfa9710d1425f7bce4e387eafb8056c8fd526935f5a661ccc74281"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm"

  uses_from_macos "libxml2"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
