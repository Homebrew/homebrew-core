class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.1.tar.gz"
  sha256 "24ab610b81fbd783874b4c6fbedeed52436b0d0aba293d91b9e678c431b092fe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b11b0de131e2c2eb5ffec2a737c3faafd6cd9f00dfaef47e767f090227e21a76"
    sha256 cellar: :any,                 arm64_sequoia: "4d1b3a972f34cd15aace9a2ef881748a339f01033c0dbec3f9f3d0c33f75e6ac"
    sha256 cellar: :any,                 arm64_sonoma:  "e7e94ab9ec856e7828da50be61e9a053183dc01e2eb59d4bf6526ba254a5ce7d"
    sha256 cellar: :any,                 sonoma:        "688654e33958307b8d7b47b5a04c49298c2b3180fac1a0cdb429a8bbeb48390a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8daa0b56264af8afe8098b900dea01a6079e7d7f1d81fcb17362780d5738d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335ed82fc8692d8823ef16dff38237a33a188702f390b600ddc85411dda00626"
  end

  # These files used to be distributed as part of the jdupes formula
  link_overwrite "include/libjodycode.h", "share/man/man7/libjodycode.7", "lib/libjodycode.a"

  # Fix compile-time errors on Linux
  patch do
    url "https://codeberg.org/jbruchon/libjodycode/commit/07294bbfd6c3c4be42c40c9ed81eebb5cd3d83a0.patch?full_index=1"
    sha256 "a9ed883dce6eeb90b20ea851247696b1b9a6f1cfbf8579cf9885ac0e3349e0d1"
  end

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
