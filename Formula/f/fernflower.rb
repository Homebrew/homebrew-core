class Fernflower < Formula
  desc "Advanced decompiler for Java bytecode"
  homepage "https://github.com/JetBrains/fernflower"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/263.7307.353/java-decompiler-engine-263.7307.353.jar"
  sha256 "e7e9182257e976ce54f820e08b075f6a65b17128334e14f6c3eb70d3ce8b742b"
  license "Apache-2.0"

  livecheck do
    url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    manifest_sha256 "bd649e560d5e4cbdf77dd5bb741447dae18639aa81aa82f20c550d8df4191c94"
    sha256 cellar: :any_skip_relocation, all: "d9f29a51927d8c875b71b2e97f636f4ef8bb888344ec60dba11902e6cd104440"
  end

  depends_on "openjdk"

  def install
    libexec.install "java-decompiler-engine-#{version}.jar"
    bin.write_jar_script libexec/"java-decompiler-engine-#{version}.jar", "fernflower"
  end

  test do
    (testpath/"Main.java").write <<~JAVA
      void main() {
        IO.println("hello world");
      }
    JAVA

    system formula_opt_bin("openjdk")/"javac", "Main.java"
    (testpath/"out").mkpath
    system bin/"fernflower", "Main.class", "out"

    output = (testpath/"out/Main.java").read.strip
    expected = <<~JAVA.strip
      final class Main {
         void main() {
            IO.println("hello world");
         }
      }
    JAVA

    assert_equal expected, output
  end
end
