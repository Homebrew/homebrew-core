class Ancient < Formula
  desc "Decompression routines for ancient formats"
  homepage "https://github.com/temisu/ancient"
  url "https://github.com/temisu/ancient/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "6f63e2765866925f1b188baee958d4518720bd0009ab4f50b390ea5028649ec2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f4d5623bd2b124de3df19da083eab30a4c50a209fd5c3669c254bfb2ecfa7eb"
    sha256 cellar: :any,                 arm64_monterey: "149881aa043f4133bdb6dac622b3cc606a44de26105b154bfa3a934f18fbb089"
    sha256 cellar: :any,                 arm64_big_sur:  "e46d1a5d1e6c8b08489a6f3d3a81fcc0ef8b9dc2c1421ccd8a3849d6f163e3ef"
    sha256 cellar: :any,                 ventura:        "37845ef9416ea76ca618aaa29bda88d46e011c24bb5fc772c27ea52b3f61dcd3"
    sha256 cellar: :any,                 monterey:       "c5dc5fa32a48cd5916c563690203da74e731a1d8a197de97ead68ce6c480a2f1"
    sha256 cellar: :any,                 big_sur:        "47ae9e68f35e4cb300c85957ef7a4f6c2bef532d32b49a476fb2eddb0967f8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91efa218bbb1adbb9dffa24d2e932df91ae5de07a7a95afb3726e271e2a7f972"
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
