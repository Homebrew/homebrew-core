class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.31.tar.gz"
  sha256 "912aa843447db8a3e7d70f5df743d6e120120e3324394ad6ed7252d23631ade1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c68671cb596365de3b624d97e5e52d1d19c5328e47dbd9145b2e09988a822e2b"
    sha256 cellar: :any,                 arm64_sonoma:  "caf4df4fc8c4400af86be20abb4601d5c3b04982f160f6c30cd185125e50b3ed"
    sha256 cellar: :any,                 arm64_ventura: "5875e9b286473e11c3a1d608310ae6c347164734b160a280260fa6bbfe753d4b"
    sha256 cellar: :any,                 sonoma:        "6bad218c039f857f3b53b59e5db5cec16b11f8c2875bfe4e1ad95c0ad0c04e2c"
    sha256 cellar: :any,                 ventura:       "ab044a3d87dfe4e85d6fcd159c331b2aa1281ed7ddc3ae55353da1fa18684706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7cc3e03ccee3c92a488ae641f8ac3344b269dce31952975ef3f087ea21518b0"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DENABLE_STATIC=ON
      -DENABLE_SUSEREPO=ON
      -DENABLE_COMPS=ON
      -DENABLE_HELIXREPO=ON
      -DENABLE_DEBIAN=ON
      -DENABLE_MDKREPO=ON
      -DENABLE_ARCHREPO=ON
      -DENABLE_CUDFREPO=ON
      -DENABLE_CONDA=ON
      -DENABLE_APPDATA=ON
      -DMULTI_SEMANTICS=ON
      -DENABLE_LZMA_COMPRESSION=ON
      -DENABLE_BZIP2_COMPRESSION=ON
      -DENABLE_ZSTD_COMPRESSION=ON
      -DENABLE_ZCHUNK_COMPRESSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end
