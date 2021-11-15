class Cityhash < Formula
  desc "Hash functions for strings"
  homepage "https://github.com/google/cityhash"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cityhash/cityhash-1.1.1.tar.gz"
  sha256 "76a41e149f6de87156b9a9790c595ef7ad081c321f60780886b520aecb7e3db4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7bdc9022f63b8137aa89ffa935b059bbb00fef7a017a4e374f85a006b6a407a"
    sha256 cellar: :any,                 arm64_big_sur:  "e43f909c5fb775ca6c05675798d12343b1187820316716a844634e1a3419e21f"
    sha256 cellar: :any,                 monterey:       "af8607ad49fe965c7d64547928d2813259a2d55dd8556f5a82bbcb6e54dfefc4"
    sha256 cellar: :any,                 big_sur:        "8ef1413a8bdd03a86b054f673462e82cdea4230fb9a75f98ada2d996bdcd0893"
    sha256 cellar: :any,                 catalina:       "ddca5903f40b8ec22ca0a2da4f116a03dc45d0f383c508f4f0370cd5899b80c3"
    sha256 cellar: :any,                 mojave:         "4d7f25360b715d36177c70f06f7c21f39d38b6b8aa9f8a5befe80818baa3545f"
    sha256 cellar: :any,                 high_sierra:    "37e8244399c42c6f3bdb2fad91562607e96bc3380378d318ceecbc16ec8d52be"
    sha256 cellar: :any,                 sierra:         "62d8d1409dfe744d4de7a1727824b06c5a80b248433c2d8bd8a4efcd444346cb"
    sha256 cellar: :any,                 el_capitan:     "b09962ca43b3bb3321e1e57bf74a0936142ec5c94e198113ac3aa14e669e4d28"
    sha256 cellar: :any,                 yosemite:       "2b155183e2422811593d91b415ac2e90a00b7d6972f284e54b3214940250935e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f381c56f8063574fc86fa4eace73e99bf9be10155f90c1881362e70aea75826a"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <inttypes.h>
      #include <city.h>

      int main() {
        const char* a = "This is my test string";
        uint64_t result = CityHash64(a, sizeof(a));
        printf("%" PRIx64 "\\n", result);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcityhash", "-o", "test"
    assert_equal "ab7a556ed7598b04", shell_output("./test").chomp
  end
end
