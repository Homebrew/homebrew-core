class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.32.tar.gz"
  sha256 "8c5957fb417823768d70e0faefa6f75f497f41289641256e4fdfecd1954fa16c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bc80f057a12b2a40d26053ae589b9131b16cef68f74493dedaec29e9931a1b6"
    sha256 cellar: :any,                 arm64_sonoma:  "3363ee930719a9550a4698243c1c8682a595196bff4842269f1b455ec2361cc7"
    sha256 cellar: :any,                 arm64_ventura: "2033c44f271b189ea8288d7ae870463e7308fe043b9feb14da0a219f5fe40c1f"
    sha256 cellar: :any,                 sonoma:        "7fa9db2506a3ca843a326757b4f2febb2fcbc549858a2093c66c62220001991d"
    sha256 cellar: :any,                 ventura:       "f7cb370401248e2a75234ccedc928809eca59ed89c25558cc5f3e5af1f3a15c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abbc5e841babfdde7d81f6eab2f0afc3130dad0793f39b41d170aa78cb4d4aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a03fd9145d161285fb486032504b3ef2a6c41a058d29e592534434f8d3ce1fc"
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
