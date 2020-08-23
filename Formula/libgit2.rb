class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.0.1.tar.gz"
  sha256 "1775427a6098f441ddbaa5bd4e9b8a043c7401e450ed761e69a415530fea81d2"
  license "GPL-2.0"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "e6456b9dde3c5ed975cc6a106e721ce63a84e37e71762889c360920c999f2b12" => :catalina
    sha256 "2187f1fd84786573d62180909d1f319c58700fa6fe662a2de93092dbde76bd16" => :mojave
    sha256 "c7c5dbf3884b241c0350404858ba4f63d640921bee6ff8142c2e214533e42761" => :high_sierra
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
