class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "https://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v20.0.1.tar.gz"
  sha256 "dab5b4ec4b68bd7dc128a1fb7900723f89d2da107e44cd5def7d38fc57252a9d"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f4d8d0c1c9c9f4d3d14efebb75b32d4cc826bc4eb78bf8325e45197b4db38cf"
    sha256 cellar: :any,                 arm64_sequoia: "ca7da3df10bb9bddb30c9a9a8f3d127148d602bfbd95fb839b44fc45df67d153"
    sha256 cellar: :any,                 arm64_sonoma:  "b6228c729790576a6dd785125528a547017531941c45560877bf64bddcdf9129"
    sha256 cellar: :any,                 sonoma:        "44dc2983b9544e2ba43cece99e7cb410d3e3ff605df6946f49ae4120f3df62d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fad7734cdad16a072ad4134a8c5ee14c031627a89fde3d6f51e866b589f32df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83a6c33227e47dfa2207a9d9125e76c3ae689955f7d33e1e51b9e2bd45495fcc"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  def install
    args = %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -Dlapack_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DDLIB_LINK_WITH_SQLITE3=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if OS.mac? && MacOS.version.requires_sse4?
    end

    system "cmake", "-S", "dlib", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    CPP
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
