class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.39.tar.gz"
  sha256 "2a74cbf1e49984cb01f75ac4b19a237f24de6ce199766858aeb9ab3aae2b95fa"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f8c754af1537c3a4bdfa36beafba00e3c0327aa8203630bbfc4659a4f3be500"
    sha256 cellar: :any,                 arm64_sequoia: "324c5b3734665fa23a33f5298557655527140c95844ce378f0eb94f0e2197b6c"
    sha256 cellar: :any,                 arm64_sonoma:  "efec1c124d205cc8db8ebd47f060807d0b5e6ec485b9ce1b9122a5079f0ffbfc"
    sha256 cellar: :any,                 sonoma:        "5f48921930095ce2fe31feb579966311356d03631ab3936c9a67325e4f6e3c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa20085a60b40439b691afeb5b942edf04dbb12d1d1595532b3c1280e6a02100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea07388c8559e8422e9f4efdfff6d546568d33a561401ea51e76377de72083f"
  end

  depends_on "cmake" => :build
  depends_on "rpm"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      -DENABLE_RPMDB=ON
      -DENABLE_RPMMD=ON
      -DENABLE_RPMPKG=ON
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
