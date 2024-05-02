class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "906559a25581b292352420721112e1656d21029b66e8597816f9e741fbcdeadb"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7ff130f6e50331505f0d4ec331753075b18782942bbe334c14766f241c4ba43"
    sha256 cellar: :any,                 arm64_ventura:  "bb609c3deef2ee7b1ee95c46d7db7ac72c40353d65dd859f7452c5552c6bc2ef"
    sha256 cellar: :any,                 arm64_monterey: "dc821a2e7978db478798519e04168edc2b395b9ebdf70cce106a2b7c58ad1284"
    sha256 cellar: :any,                 sonoma:         "ccbb5400b3cbd7e137862bdfbbd80bce5571dcdb5832e1e7539e18032bc505e7"
    sha256 cellar: :any,                 ventura:        "348d33d19c25d60b19273a9ec96f3b22200eb5e474133b85be9c88ecb90216bc"
    sha256 cellar: :any,                 monterey:       "c4d4d844cfbfb3b5a12468ceb83a3390d1ce61ff74371d712450237962d934e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f9a9dee3ec31ef4121ce2294a0958b33c9b98a94d41c515c093afeb9e72437"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
