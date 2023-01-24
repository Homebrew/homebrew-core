class Ancient < Formula
  desc "Decompression routines for ancient formats"
  homepage "https://github.com/temisu/ancient"
  url "https://github.com/temisu/ancient/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9c6b31e4d968ec3adb25596a0b30405d1080d3de0546f1485ecb0ac2eca6261d"
  license "BSD-2-Clause"

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ancient/ancient.hpp>

      int main(int argc, char **argv)
      {
        std::optional<ancient::Decompressor> decompressor;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lancient", "-o", "test"
    system "./test"

    system bin/"ancient", "scan", testpath, testpath
  end
end
