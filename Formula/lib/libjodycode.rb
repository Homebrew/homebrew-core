class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.1.1.tar.gz"
  sha256 "dba58704f269d82bc226d361e40c2e0fc627dbdcc29786b74942c1afe5092132"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fb9785e42d54ca8785437d4e5e88bc174cb9cdec69e8cd91e08773475bd6d15"
    sha256 cellar: :any,                 arm64_sequoia: "1de8fff8cb97dc6b75abb29d79e99be062ad71b4920b66102b4105eadff922cf"
    sha256 cellar: :any,                 arm64_sonoma:  "997ccd481d19913e259e63d80ccb8ceb0f19b54dbeea27a40423af0915849c30"
    sha256 cellar: :any,                 sonoma:        "7af2eb2f6abfd048a2c5a78e3733a4a599cd12472134b68617ba5efe4a0c7845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "840eb3be0573968cfd6c664ef2ac0fe424b864405254b67bd640fe749bf44089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1257a5f234e39badf6f52d8a1a2f444664e78879379ef97067c5fce59555c0d2"
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
