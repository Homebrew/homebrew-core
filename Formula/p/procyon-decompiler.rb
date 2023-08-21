class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond"
  homepage "https://github.com/mstrobel/procyon"
  url "https://github.com/mstrobel/procyon/releases/download/v0.6.0/procyon-decompiler-0.6.0.jar"
  sha256 "821da96012fc69244fa1ea298c90455ee4e021434bc796d3b9546ab24601b779"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee55d23c048aa221e0f2c76eaa0ac264f83b0ac6ebf7388479878cc387fad122"
  end

  depends_on "openjdk"

  def install
    libexec.install "procyon-decompiler-#{version}.jar"
    bin.write_jar_script libexec/"procyon-decompiler-#{version}.jar", "procyon-decompiler"
  end

  test do
    fixture = <<~EOS
      class T
      {
          public static void main(final String[] array) {
              System.out.println("Hello World!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system "#{Formula["openjdk"].bin}/javac", "T.java"
    assert_match fixture, pipe_output([bin/"procyon-decompiler", "T.class"])
  end
end
