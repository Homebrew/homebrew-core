class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.25.tar.gz"
  sha256 "b382bba4196b19c36eb34e0ef02546c0b922be601c6f73390c9ab643895b656a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4cab2bf293efaa010409a29f0f103a15e1b66df4a1afd179f74fb18d95725822"
    sha256 cellar: :any,                 arm64_ventura:  "a2faae4d134eeb5460b19f98d0b504f539575965415681ff3d1285b3b3c21c78"
    sha256 cellar: :any,                 arm64_monterey: "3dac610064d8a92260f060190c3b7decda2b9583177ae3e55cb1a5f0052b5dcc"
    sha256 cellar: :any,                 arm64_big_sur:  "41a1c5e694874952b7edc3c8eb760182cf5d4245016e162a16ae6254ad5f263f"
    sha256 cellar: :any,                 sonoma:         "36f902790c1f5391f2a16b536145f17a877155e48bfb0e513c5f54d3c78cc144"
    sha256 cellar: :any,                 ventura:        "25a22343e97f06ec995f1b7730b54ae9745eddf40e4e78b3cca834594ab34715"
    sha256 cellar: :any,                 monterey:       "39a513696e2135e80891e613bd17eb904d7e395d6f279446ade54d1722ebf69f"
    sha256 cellar: :any,                 big_sur:        "737642d50c0885af0af2f795305bf84b9e22e2cba9625d1ad2bebf04a10ba25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9784c26d446e87a346a04a04616f8a087138d20f0ef44409305a64869c82c1b9"
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
