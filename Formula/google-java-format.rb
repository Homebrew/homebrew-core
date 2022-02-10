class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.14.0/google-java-format-1.14.0-all-deps.jar"
  sha256 "0d27d3e58c3a9d91d89b424d467fabde24e8c67b4662606153bcd01b383ebd77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "092f89e63ef8e627e7a1601bbf78a8de3e5e2d3a8854ca0d19bcd793c3e57f76"
  end

  depends_on "openjdk"
  depends_on "python@3.10"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.14.0/scripts/google-java-format-diff.py"
    sha256 "4c46a4ed6c39c2f7cbf2bc7755eefd7eaeb0a3db740ed1386053df822f15782b"
  end

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec / "google-java-format.jar", "google-java-format",
      "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"
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
