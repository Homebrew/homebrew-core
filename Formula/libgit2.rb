class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.6.2.tar.gz"
  sha256 "d557fbf35557bb5df53cbf38ae0081edb4a36494ec0d19741fa673e509245f8f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55501cf2783f6a061987b86f18aacdc4e7c03ee5093c883c759d0505b256c3dd"
    sha256 cellar: :any,                 arm64_monterey: "0ec5971167bbcf63329d5ca7c22c5da67482acaace2eb0cdd8258bbd46bb53dc"
    sha256 cellar: :any,                 arm64_big_sur:  "653d16572d7d2ac15dd337f22ac22a19fbd865b65ebb707fd4621bfb25e3359c"
    sha256 cellar: :any,                 ventura:        "34473dfb6d2a9513ee3c8d0792ea84e421fe5087e544db89f77ecd777b10816c"
    sha256 cellar: :any,                 monterey:       "9da554c358c97a0da768f241f362d22cb54abf590ad6513c744bc4f7a9bf0e65"
    sha256 cellar: :any,                 big_sur:        "1826fdcc1ab8e4d15feee6a5c3274bc9e004b277f4421aeddc09e6dca29bc040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97a3ecf40d5f5885f19169a5cb8aeff10e769e274484f6f5fcd3bdbb76661a7a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libgit2.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
