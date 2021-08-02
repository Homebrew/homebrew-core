class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.12.0/google-java-format-1.12.0-all-deps.jar"
  sha256 "85da82b9b71f04afcacda9d008c2d21540bf4fa259269efb5c561da2d4e11252"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7dccb80af3364f807fd943e8315cd53c4eb6413744245885dd171d820937cd36"
    sha256 cellar: :any_skip_relocation, big_sur:       "7dccb80af3364f807fd943e8315cd53c4eb6413744245885dd171d820937cd36"
    sha256 cellar: :any_skip_relocation, catalina:      "7dccb80af3364f807fd943e8315cd53c4eb6413744245885dd171d820937cd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e32c09781e5e93774ffeb6dd74e05512af27a609989db0bfff26a47eef279a"
  end

  depends_on "openjdk"
  depends_on "python@3.10"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.12.0/scripts/google-java-format-diff.py"
    sha256 "f6d049b0a9d7cdbeca2d4cf79667ad95da30810ad67cc308f48e75f8565cbb64"
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
