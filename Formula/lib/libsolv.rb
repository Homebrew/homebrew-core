class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.28.tar.gz"
  sha256 "bd2406f498fea6086ae0eacbf8b188c98b380e59af2267170e6a7b7d715cb207"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33604ecf0b95948a5fce5c4c7e11a30bffa7296e0515b07bbd9f1ab8fb3f9c40"
    sha256 cellar: :any,                 arm64_ventura:  "52e06ab7ad593319e94330327203be5a6f9fd08f0fd94fb897d08b6515656e62"
    sha256 cellar: :any,                 arm64_monterey: "f2e955028a296e64f72dd2b173fe807d72bc3628840576abf4c99d3b44bde411"
    sha256 cellar: :any,                 sonoma:         "1555f5298503662c42857f839b9aab2b78bfec08f13d42e34f0004bded31ffa0"
    sha256 cellar: :any,                 ventura:        "5b81885168ed747fad82bb28195c289f96562d569bc5dc7a57775eab5f8e7210"
    sha256 cellar: :any,                 monterey:       "0ffb8c0caa8743602dc02a33b56fa39c00b8e89717f0bd33a4f4d4ecb0601bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f20cc3a707ab8e4f0c6829f16f7678ef24f3458904530d9b8bfdc809fa5139b"
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
    (testpath/"test.cpp").write <<~EOS
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end
