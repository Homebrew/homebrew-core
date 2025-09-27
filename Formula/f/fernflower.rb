class Fernflower < Formula
  desc "Advanced decompiler for Java bytecode"
  homepage "https://github.com/JetBrains/fernflower"
  url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/252.25557.131/java-decompiler-engine-252.25557.131.jar"
  sha256 "d41310023d74a5c4a89d4fc7202f47ddc1a2770da4807b1752453813904ae010"
  license "Apache-2.0"

  livecheck do
    url "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  depends_on "openjdk"

  def install
    libexec.install "java-decompiler-engine-#{version}.jar"
    bin.write_jar_script libexec/"java-decompiler-engine-#{version}.jar", "fernflower"
  end

  test do
    (testpath/"Main.java").write <<~EOS
      void main() {
        IO.println("hello world");
      }
    EOS

    system Formula["openjdk"].opt_bin/"javac", "Main.java"
    mkdir "out"
    system bin/"fernflower", "Main.class", "out"

    output = (testpath/"out/Main.java").read.strip
    expected = <<~EOS.strip
      final class Main {
         void main() {
            IO.println("hello world");
         }
      }
    EOS

    assert_equal expected, output
  end
end
