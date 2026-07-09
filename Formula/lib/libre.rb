class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "2094822477e4b68bf03089fe29b43b5160103ba846847004df25f9e3d65fabb6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4ba8767b6f68741df63d26584ebb411b7b303beb125cff5788538aa1c4d174b"
    sha256 cellar: :any, arm64_sequoia: "e6f97db3705fc214b78ebc8ffe2757c02727e3c9356ea48f49457faf6e4117e9"
    sha256 cellar: :any, arm64_sonoma:  "14eacfc6dfc49ee52a12889f0bf0272c63b98fa5e4045f1575568014c28fe471"
    sha256 cellar: :any, sonoma:        "969911b1390d035dff7e44ace13c6e8bb6d6473a637d9276610179ecf26da3ec"
    sha256 cellar: :any, arm64_linux:   "71e69e0b835956784d2dfd866061fc7e960bb43c9498a0514c9021d2b83c834b"
    sha256 cellar: :any, x86_64_linux:  "8b6c1f048213dfa1a0bec444c643bfe67c3eb8671f218d38bcb88db3c6c72161"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{include}/re", "-L#{lib}", "-lre"
    system "./test"
  end
end
