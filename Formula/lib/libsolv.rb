class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.29.tar.gz"
  sha256 "cb8d36a345ea9491f75d88c3a36a6f575c4e25f08197562f7ab0aa1c6e8c6abd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a70ba53840597f8de65c06576e9a5d88892ea6a4b380d4a26872e051ca334539"
    sha256 cellar: :any,                 arm64_ventura:  "41605225e942e3e0e5621b54b5f4d489557aba35f51a252adfabc22b11635f86"
    sha256 cellar: :any,                 arm64_monterey: "26fe7182fd012888b8124dad5d7f7a2bdd5ca777fc6f15675dd1e4174b4b3ea8"
    sha256 cellar: :any,                 sonoma:         "bd39d1a95df35a86d5dee584d851ad615f296ee005f7a4696ceb604468791c21"
    sha256 cellar: :any,                 ventura:        "8604969fa94a3d76e6b8cd4d52e74ec4c16540fa8479331a43b9415aded99c9a"
    sha256 cellar: :any,                 monterey:       "40688db345013b8f1854e76cbd7b9a64efaa0e127b6d5d443dd47106873b6eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d95699cda764bd5961ad3b049aa0c9d1013a3e9de59e086648165f6f2c1b73"
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
