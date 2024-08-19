class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.23.0/google-java-format-1.23.0-all-deps.jar"
  sha256 "7c6375ac24b4825be6bbe61900e8b58b1a3e8944a1367a8363210f9ed2d08570"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be0c8abed3e983a3802fbb131113aaf96fd4e9a413cdc8b47a5145d8a79ce41b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be0c8abed3e983a3802fbb131113aaf96fd4e9a413cdc8b47a5145d8a79ce41b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be0c8abed3e983a3802fbb131113aaf96fd4e9a413cdc8b47a5145d8a79ce41b"
    sha256 cellar: :any_skip_relocation, sonoma:         "be0c8abed3e983a3802fbb131113aaf96fd4e9a413cdc8b47a5145d8a79ce41b"
    sha256 cellar: :any_skip_relocation, ventura:        "be0c8abed3e983a3802fbb131113aaf96fd4e9a413cdc8b47a5145d8a79ce41b"
    sha256 cellar: :any_skip_relocation, monterey:       "be0c8abed3e983a3802fbb131113aaf96fd4e9a413cdc8b47a5145d8a79ce41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "526ece906208ab12abfcc5607e650c5a85e5dce46652d061c3a5385e25f810b6"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.23.0/scripts/google-java-format-diff.py"
    sha256 "c1f2c6e8af0fc34a04adfcb01b35e522a359df5da1f5db5102ca9e0ca1f670fd"
  end

  def install
    if version != resource("google-java-format-diff").version
      odie "google-java-format-diff resource needs to be updated"
    end

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
  end
end
