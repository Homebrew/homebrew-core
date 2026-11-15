class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.2.tar.gz"
  sha256 "eeb54fc50b9ebec4e43c954704e69f56c104fede67aaee9f375fbecbb87933b0"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83e23477ee5a814cd9f6801c5d8fcad6161ba6dc1d941cfb620474a25eaa9176"
    sha256 cellar: :any, arm64_tahoe:       "073330f62fd7c97addcf3b43fd146b401b9cc2801fc5fc44e7369f55f2b6c8af"
    sha256 cellar: :any, arm64_sequoia:     "2431749499aabc426faa6f7108f5eea6b5112ed9160cf32232dc4a8e3e9bc9ed"
    sha256 cellar: :any, arm64_linux:       "eb03e31193bda2be8b75368c1e26caaf364eed93271fbc4bf859993f2a0ac4b9"
    sha256 cellar: :any, x86_64_linux:      "0b2096e2952453b9016c2f306361fef6ea335f5bdd07c04a7d47faf667f84dbb"
  end

  # These files used to be distributed as part of the jdupes formula
  link_overwrite "include/libjodycode.h", "share/man/man7/libjodycode.7", "lib/libjodycode.a"

  deny_network_access!

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
