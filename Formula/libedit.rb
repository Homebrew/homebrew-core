class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20190324-3.1.tar.gz"
  version "20190324-3.1"
  sha256 "ac8f0f51c1cf65492e4d1e3ed2be360bda41e54633444666422fbf393bba1bae"

  bottle do
    cellar :any
    sha256 "46e6433799898fe243615048d7af2edc137a817d02d27a11895e9f4b0981324b" => :catalina
    sha256 "c445caf1a4f1d47555f00505553b479c1638eb59e63ce7bcbd9cc03fd4b15e14" => :mojave
    sha256 "0b624516c27f8e3298eff0f2dbfd2e108bf6d428c6d7c057914665b26154b366" => :high_sierra
    sha256 "8ad985a00377f40928cb2653675da86542678baf2b625eb9861638b4c31878a8" => :sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
