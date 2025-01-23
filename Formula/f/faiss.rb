class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a6c3c60811aeec2dd8943a41f3df244bfed12371453d9b10eaf6ba55fafad1d2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26ea150f8723f7ebacf858a6d470e1a5fd8145efc4d1080b41e9be6ed7e5e993"
    sha256 cellar: :any,                 arm64_sonoma:  "dd7330aa740c100fd29ecee133a84a548171317625ebabc0d8892ac753ac7691"
    sha256 cellar: :any,                 arm64_ventura: "4a6e113023669f5365fd8dc6d3b28992e62d11146e0eb214669ea164cd629ffd"
    sha256 cellar: :any,                 sonoma:        "a582b7928a12b018566d99d86dd631eac1be0e52ab67fe6a1ac1049559ac726a"
    sha256 cellar: :any,                 ventura:       "1b52e795c1aff5f0aad25ef87a614129d01a9e35a6f611ea193af29f4307b1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b2f1ec81e5889a31d5196b95b5a412cfa8806033c67351cb638105381161f2"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = *std_cmake_args + %w[
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
      -DFAISS_ENABLE_C_API=ON
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-B", "build", ".", *args
    cd "build" do
      system "make"
      system "make", "install"
    end
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++11", "demo_imi_flat.cpp", "-L#{lib}", "-lfaiss", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
