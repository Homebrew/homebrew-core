class Libjodycode < Formula
  desc "Shared code used by several utilities written by Jody Bruchon"
  homepage "https://codeberg.org/jbruchon/libjodycode"
  url "https://codeberg.org/jbruchon/libjodycode/archive/v4.0.1.tar.gz"
  sha256 "d0365b8b0762a79c3ff7913234099091c365fcae125436343224b4e39da85087"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c967c91be13fd50acd16eb93655d54663345cfba752e856da47ab220c6ddf7d9"
    sha256 cellar: :any,                 arm64_sequoia: "6d3eef0d94ad65f2c78d585d0c0f1e2a74ce6d929c20db6cef2e96df576aff22"
    sha256 cellar: :any,                 arm64_sonoma:  "b8d20edda315be556fd5c6bb18a4482b5b41c5e7c6a706cdf3522ef677e4cd7f"
    sha256 cellar: :any,                 arm64_ventura: "84c2bea836781ba9fcfcca0c99f74e955b01cc71335305c1287fbf1497963f38"
    sha256 cellar: :any,                 sonoma:        "7193d489f1cbbbbc6bb95ffb76665a19d4409496c9a660e87b64c7986f739404"
    sha256 cellar: :any,                 ventura:       "b48b1fcead2e9a95606d2ed2a74bb1b3afee0b90b1da86fae015a2f1dca553a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6b3dc1d84377b4d9e2361a9da9cf0bdbd84148b42575f9c02dafc7366b216b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b5e80463eb0fc77580954d45094da4935e3005674463492be4c9891bf15891"
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
