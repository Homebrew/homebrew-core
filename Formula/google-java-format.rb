class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.16.0/google-java-format-1.16.0-all-deps.jar"
  sha256 "82819a2c5f7067712e0233661b864c1c034f6657d63b8e718b4a50e39ab028f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f22cf26e206413e8918181eee06baa5c8e84447d40bf45277ee572c26246ac2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22cf26e206413e8918181eee06baa5c8e84447d40bf45277ee572c26246ac2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f22cf26e206413e8918181eee06baa5c8e84447d40bf45277ee572c26246ac2f"
    sha256 cellar: :any_skip_relocation, ventura:        "f22cf26e206413e8918181eee06baa5c8e84447d40bf45277ee572c26246ac2f"
    sha256 cellar: :any_skip_relocation, monterey:       "f22cf26e206413e8918181eee06baa5c8e84447d40bf45277ee572c26246ac2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22cf26e206413e8918181eee06baa5c8e84447d40bf45277ee572c26246ac2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221be794ab1ab9dd5227f2e94eeb2cac036a6ed7bfa9a7ae3e27bf1d3c855f20"
  end

  depends_on "openjdk"
  depends_on "python@3.11"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.16.0/scripts/google-java-format-diff.py"
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
