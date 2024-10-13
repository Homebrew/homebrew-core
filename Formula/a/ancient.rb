class Ancient < Formula
  desc "Decompression routines for ancient formats"
  homepage "https://github.com/temisu/ancient"
  url "https://github.com/temisu/ancient/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "d814b0a1f2c08cb7e8dc94506c096f21471719a6f9d3d2f93ab9416f1ea98712"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6f1107e987a8027289e5c8e7c95b71e85b75a94d0219df48eac31504bbb427b4"
    sha256 cellar: :any,                 arm64_sonoma:   "1dd610a8f47fb9887ed822f63899eb3cbadcad4d0be848aac8e4dd2bd12105ee"
    sha256 cellar: :any,                 arm64_ventura:  "cb400c604791468287b32dbb9d5f44b591f0ab9ca2cfccf4b12204eb7f1029ae"
    sha256 cellar: :any,                 arm64_monterey: "038e7397ac6c20fa7a424bf5565504fc669e986bda08600379c297c9e15bffc4"
    sha256 cellar: :any,                 sonoma:         "63a480cf9de0421b71aa903cb413749468b3fb6d6d7298566512fae532218d17"
    sha256 cellar: :any,                 ventura:        "a449ffd0b1f136e18e93f8c9f7e12a41c06f8e3fc29096f8b17a356cff43fe64"
    sha256 cellar: :any,                 monterey:       "c4f2396ffc6013ba685be7a0193afac0a7fa5563471829bf97c5241ca9146cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd132df16f6c1a05eb3eda0807ba65ec02deb30aa03d5b7ca39ee4172b725321"
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
  end
end
