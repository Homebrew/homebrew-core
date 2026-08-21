class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.1.2.tar.gz"
  sha256 "0343cf2ff53fb19887663b8c1f47210fc2d1599a4a8f95e292991d5b1034bc05"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0cf544850a13ea319614e60d0adaaf8a0569877f7f98b84d055c9c8205521fa1"
    sha256 cellar: :any, arm64_sequoia: "1214902f70141379d7786f2abf597e4f08cf7f569cab23ef42423b413aa1fbbb"
    sha256 cellar: :any, arm64_sonoma:  "ba8022b4f7c9d9ab4d6d77c65a2678f6566a8ccc58ffcb0247a666ce8a93457a"
    sha256 cellar: :any, sonoma:        "9bc9879bea3b4c49a46cc4ee4e2f8476664cf66c3351e7f74045af536e6dab95"
    sha256 cellar: :any, arm64_linux:   "ce11b85bffe45143b963210c3838a8f8e51cf49b0deb41f697bead8315c2a20b"
    sha256 cellar: :any, x86_64_linux:  "f10e4029e4e88cd570d668edc7c4023b0062acd0690d84bbae981e1c2af0a795"
  end

  # These files used to be distributed as part of the jdupes formula
  link_overwrite "include/libjodycode.h", "share/man/man7/libjodycode.7", "lib/libjodycode.a"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libjodycode.h>

      int main() {
          int a = jc_strncaseeq("foo", "FOO", 3);
          int b = jc_strncaseeq("foo", "bar", 3);
          int c = jc_strneq("foo", "foo", 3);
          int d = jc_strneq("foo", "FOO", 3);
          printf("%d\\n%d\\n%d\\n%d", a, b, c, d);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljodycode", "-o", "test"
    assert_equal [0, 1, 0, 1], shell_output("./test").lines.map(&:to_i)
  end
end
