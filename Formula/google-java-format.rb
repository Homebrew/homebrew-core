class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.12.0/google-java-format-1.12.0-all-deps.jar"
  sha256 "85da82b9b71f04afcacda9d008c2d21540bf4fa259269efb5c561da2d4e11252"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7dccb80af3364f807fd943e8315cd53c4eb6413744245885dd171d820937cd36"
    sha256 cellar: :any_skip_relocation, big_sur:       "7dccb80af3364f807fd943e8315cd53c4eb6413744245885dd171d820937cd36"
    sha256 cellar: :any_skip_relocation, catalina:      "7dccb80af3364f807fd943e8315cd53c4eb6413744245885dd171d820937cd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e32c09781e5e93774ffeb6dd74e05512af27a609989db0bfff26a47eef279a"
  end

  depends_on "openjdk"

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec / "google-java-format.jar", "google-java-format",
      "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
  end
end
