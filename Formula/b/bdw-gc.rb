class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.2.4/gc-8.2.4.tar.gz"
  sha256 "3d0d3cdbe077403d3106bb40f0cbb563413d6efdbb2a7e1cd6886595dec48fc2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ffeee2e44d95f98084f2731eb73bc1999c590450a4db638a97809d49cc0b3c2"
    sha256 cellar: :any,                 arm64_ventura:  "d72bbcd333cb094f8420140377f52d180215cb9da36e6ee2e7844131dd3893e6"
    sha256 cellar: :any,                 arm64_monterey: "341fca69e636872e81ba36d11455fd0d0a0ab212118bf0c08650965ee4507df7"
    sha256 cellar: :any,                 arm64_big_sur:  "3d80fe2490ea0f7a74c456c3d48096deb084a354f9be2efe600628307345cf9f"
    sha256 cellar: :any,                 sonoma:         "d02f93d22decb3760448e03e737b383cb370904f5637e9240f563e8d6ece9d58"
    sha256 cellar: :any,                 ventura:        "7eb544c73ee1bff67ec56f1a3f980b6baf92a19f1189b0d06b3ea90d69dd7554"
    sha256 cellar: :any,                 monterey:       "c7767f6818d404d1dd7d15c14b6b7cd14fe51016c601c337b3a73b4ab12655c2"
    sha256 cellar: :any,                 big_sur:        "82a7fec30efbcc9927471602771d96fa824d413764add2d8c9fb9e1487195ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f652d04db5c62c5bb5c6a974886b883ecddbd780ef960070ae1fcdfbab887acf"
  end

  head do
    url "https://github.com/ivmai/bdwgc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gcc" => :test
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus",
                          "--enable-static",
                          "--enable-large-config"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include "gc.h"

      int main(void)
      {
        int i;

        GC_INIT();
        for (i = 0; i < 10000000; ++i)
        {
          int **p = (int **) GC_MALLOC(sizeof(int *));
          int *q = (int *) GC_MALLOC_ATOMIC(sizeof(int));
          assert(*p == 0);
          *p = (int *) GC_REALLOC(q, 2 * sizeof(int));
        }
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgc", "-o", "test"
    system "./test"
  end
end
