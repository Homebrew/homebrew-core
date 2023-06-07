class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar"
  sha256 "33068bbbdce1099982ec1171f5e202898eb35f2919cf486141e439fc6e3a4203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "054e43aaed2400e8859c99041b1a5d60dfda0049f18e0c7e33746810867ff68b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054e43aaed2400e8859c99041b1a5d60dfda0049f18e0c7e33746810867ff68b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "054e43aaed2400e8859c99041b1a5d60dfda0049f18e0c7e33746810867ff68b"
    sha256 cellar: :any_skip_relocation, ventura:        "054e43aaed2400e8859c99041b1a5d60dfda0049f18e0c7e33746810867ff68b"
    sha256 cellar: :any_skip_relocation, monterey:       "054e43aaed2400e8859c99041b1a5d60dfda0049f18e0c7e33746810867ff68b"
    sha256 cellar: :any_skip_relocation, big_sur:        "054e43aaed2400e8859c99041b1a5d60dfda0049f18e0c7e33746810867ff68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd1aff51148daf13a673de54db9a8c784abce912022214cadc682245f04f500"
  end

  depends_on "openjdk"
  depends_on "python@3.11"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.17.0/scripts/google-java-format-diff.py"
    sha256 "4c46a4ed6c39c2f7cbf2bc7755eefd7eaeb0a3db740ed1386053df822f15782b"
  end

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec/"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
      rewrite_shebang detected_python_shebang, bin/"google-java-format-diff"
    end
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
    (testpath/"bar.java").write <<~BAR
      class Bar{
        int  x;
      }
    BAR
    patch = <<~PATCH
      --- a/bar.java
      +++ b/bar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    PATCH
    `echo '#{patch}' | #{bin}/google-java-format-diff -p1 -i`
    assert_equal <<~BAR, File.read(testpath/"bar.java")
      class Bar{
        int x;
      }
    BAR
    assert_equal version, resource("google-java-format-diff").version
  end
end
