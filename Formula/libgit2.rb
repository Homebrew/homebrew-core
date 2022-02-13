class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.4.2.tar.gz"
  sha256 "901c2b4492976b86477569502a41c31b274b69adc177149c02099ea88404ef19"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d648370b7a2b9713e9ca4b151e3204de78b3acc4f5841c8e9152002447402d48"
    sha256 cellar: :any,                 arm64_big_sur:  "0413adf01a5a5fe0f63933ec7850c5a638cf1e67dd5a371da6b8c63a154c2a2a"
    sha256 cellar: :any,                 monterey:       "426cbbe5464b73d9255f1ae3cccba1a241245b81203ac28e36b428bbd6bb32b8"
    sha256 cellar: :any,                 big_sur:        "12bd50433d0bcf5d85b10c609e78c28563c86c9022ffd420cd0a892875b1fa06"
    sha256 cellar: :any,                 catalina:       "9e9053beefb103cca13bd58bb701c8894c0b11be7235570a9836a18499a4f054"
    sha256 cellar: :any,                 mojave:         "f954042fedcf3c8b71b0a28395fad9c0af34d769155c9427208d71f5b5cf98b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df3234f89f7c5bbb15dfa10d0df247f3618fbd005e434397d27385b8d7536ca"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
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
