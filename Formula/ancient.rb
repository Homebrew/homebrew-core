class Ancient < Formula
  desc "Decompression routines for ancient formats"
  homepage "https://github.com/temisu/ancient"
  url "https://github.com/temisu/ancient/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9c6b31e4d968ec3adb25596a0b30405d1080d3de0546f1485ecb0ac2eca6261d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec3214e2db259ba475085d73e48e3064b183c1f1b6ac2ea14e48382d58051212"
    sha256 cellar: :any,                 arm64_monterey: "27998eba9be69e5b99170902830d7e42f27a1ce68f44b8335403bddad391f6a0"
    sha256 cellar: :any,                 arm64_big_sur:  "9aba619045bd0fcb09cf80fb40526051577441ec7e45638a78134d192b56e6d9"
    sha256 cellar: :any,                 ventura:        "c7716c400c21530fb86e3d5338aa3c8a821b167af5c1141601f6e3d69345782e"
    sha256 cellar: :any,                 monterey:       "8498270f1c764e1c487358146e6b4b179953a2f7ba69a49282c0fafdac5180f7"
    sha256 cellar: :any,                 big_sur:        "327d16f754e9de4b888a12891c36b9ca86592f5b0e71f336ef08cc0993abc840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470e174088daa85697bdad08a9cc408b60a37bee33e874b2f81a4a2f11c7fcb2"
  end

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
