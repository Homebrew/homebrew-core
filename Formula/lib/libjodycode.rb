class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.1.2.tar.gz"
  sha256 "a7085da591e0c314eb3442e7b258a6b6944e6978ecb2764ab33f3cb840f47ff4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbf0084259a113c633054d13f127c2aadb4bb670a1016f020b92c21d9aa17ff2"
    sha256 cellar: :any,                 arm64_sequoia: "f942693372181f793814c287c4187e2eb8bc44fc02f9ad9c0537693c496af973"
    sha256 cellar: :any,                 arm64_sonoma:  "1df1a7a4d35139f0e3f1a45261ec1667688a21ebc34c9b00fbbc8866b445a560"
    sha256 cellar: :any,                 sonoma:        "982e433a5603a6b091b884171edab27a4df399a641c55db26f98bf393593f6cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56b85c6feda4344b3b5609ff88f7391f48b9264dbbfbd3ad6ecc55038393060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0585287d1de468c0e1f3ae89d22e78827f76c527baaed13424629c3d2e5ad0"
  end

  # These files used to be distributed as part of the jdupes formula
  link_overwrite "include/libjodycode.h", "share/man/man7/libjodycode.7", "lib/libjodycode.a"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libjodycode.h>

      int main() {
          int a = jc_strncaseeq("foo", "FOO", 3);
          int b = jc_strncaseeq("foo", "bar", 3);
          int c = jc_strneq("foo", "foo", 3);
          int d = jc_strneq("foo", "FOO", 3);
          printf("%d\\n%d\\n%d\\n%d", a, b, c, d);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljodycode", "-o", "test"
    assert_equal [0, 1, 0, 1], shell_output("./test").lines.map(&:to_i)
  end
end
