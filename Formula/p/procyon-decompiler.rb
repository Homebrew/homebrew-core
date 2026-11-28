class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond"
  homepage "https://github.com/mstrobel/procyon"
  url "https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar"
  sha256 "821da96012fc69244fa1ea298c90455ee4e021434bc796d3b9546ab24601b779"
  license "Apache-2.0"

  bottle do
    rebuild 2
    manifest_sha256 "382821a9df0df6483021df7b1b8e07c07f4e62e35c0ce4d8dd8cffbeff58184f"
    sha256 cellar: :any_skip_relocation, all: "6d383fdfc3e0cd6e98271bc33299c2553943305e40c4cc48b127ab4157dff604"
  end

  depends_on "openjdk@21"

  def install
    libexec.install "procyon-decompiler-#{version}.jar"
    bin.write_jar_script libexec/"procyon-decompiler-#{version}.jar", "procyon-decompiler", java_version: "21"
  end

  test do
    fixture = <<~JAVA
      class T
      {
          public static void main(final String[] array) {
              System.out.println("Hello World!");
          }
      }
    JAVA

    (testpath/"T.java").write fixture
    system dep("openjdk").opt_bin/"javac", "T.java"
    assert_match fixture, shell_output("#{bin}/procyon-decompiler T.class")
  end
end
