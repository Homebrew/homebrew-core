class Cityhash < Formula
  desc "Hash functions for strings"
  homepage "https://github.com/google/cityhash"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cityhash/cityhash-1.1.1.tar.gz"
  sha256 "76a41e149f6de87156b9a9790c595ef7ad081c321f60780886b520aecb7e3db4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ce559172129f8c960379c6cfc4f513d8dce917f386f4471f1a1ab5766a0acffd"
    sha256 cellar: :any,                 arm64_sonoma:   "5a0d0a8fd944f2ce605734f896bf19bf634378f6754d604b026a22692f461361"
    sha256 cellar: :any,                 arm64_ventura:  "8b40df9470428bbabbd02a72658b34469a59c14d41f2782d0c6cd657aaa7613e"
    sha256 cellar: :any,                 arm64_monterey: "a7bdc9022f63b8137aa89ffa935b059bbb00fef7a017a4e374f85a006b6a407a"
    sha256 cellar: :any,                 arm64_big_sur:  "e43f909c5fb775ca6c05675798d12343b1187820316716a844634e1a3419e21f"
    sha256 cellar: :any,                 sonoma:         "bcc3ba4da5829115dcae4e1f57a6795a33ca041d356a1f97f02a440bbe8d033a"
    sha256 cellar: :any,                 ventura:        "e28b61cd0edb007b53f6effd11dda5b1b40e694dd6fb19a23aaf2c30105e5952"
    sha256 cellar: :any,                 monterey:       "af8607ad49fe965c7d64547928d2813259a2d55dd8556f5a82bbcb6e54dfefc4"
    sha256 cellar: :any,                 big_sur:        "8ef1413a8bdd03a86b054f673462e82cdea4230fb9a75f98ada2d996bdcd0893"
    sha256 cellar: :any,                 catalina:       "ddca5903f40b8ec22ca0a2da4f116a03dc45d0f383c508f4f0370cd5899b80c3"
    sha256 cellar: :any,                 mojave:         "4d7f25360b715d36177c70f06f7c21f39d38b6b8aa9f8a5befe80818baa3545f"
    sha256 cellar: :any,                 high_sierra:    "37e8244399c42c6f3bdb2fad91562607e96bc3380378d318ceecbc16ec8d52be"
    sha256 cellar: :any,                 sierra:         "62d8d1409dfe744d4de7a1727824b06c5a80b248433c2d8bd8a4efcd444346cb"
    sha256 cellar: :any,                 el_capitan:     "b09962ca43b3bb3321e1e57bf74a0936142ec5c94e198113ac3aa14e669e4d28"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "729ba06d00e0929bb6e553259a22690423d14593d2b792695ec29ec80d21455e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f381c56f8063574fc86fa4eace73e99bf9be10155f90c1881362e70aea75826a"
  end

  on_linux do
    on_arm do
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "libtool" => :build
    end
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.linux? && Hardware::CPU.arm?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include <inttypes.h>
      #include <city.h>

      int main() {
        const char* a = "This is my test string";
        uint64_t result = CityHash64(a, sizeof(a));
        printf("%" PRIx64 "\\n", result);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcityhash", "-o", "test"
    assert_equal "ab7a556ed7598b04", shell_output("./test").chomp
  end
end
