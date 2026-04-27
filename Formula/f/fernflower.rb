class Fernflower < Formula
  desc "Advanced decompiler for Java bytecode"
  homepage "https://github.com/JetBrains/fernflower"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/261.23567.138/java-decompiler-engine-261.23567.138.jar"
  sha256 "42c80bd7ffbd27f156f949040da2db04c5d1c230a05931cc4bf75d10adeb1cb0"
  license "Apache-2.0"

  livecheck do
    url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ae48af7bd784bfb95194c50b3df4125dee19e4938bc29ed165d826b0508b64e"
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

    system Formula["openjdk"].opt_bin/"javac", "Main.java"
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
