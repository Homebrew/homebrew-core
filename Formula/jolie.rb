class Jolie < Formula
  desc "The Jolie Language Interpreter"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.9.1/jolie-1.9.1.jar"
  sha256 "e4b43f2b247102f49c05fb48d64ca294141b3488de38bd089c99653ca83c644d"
  license "LGPL-2.1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8aecb9822259d55665704df3939d474d4c86de04979d4f8cf244a4cf2ba3150" => :catalina
    sha256 "f8aecb9822259d55665704df3939d474d4c86de04979d4f8cf244a4cf2ba3150" => :mojave
    sha256 "f8aecb9822259d55665704df3939d474d4c86de04979d4f8cf244a4cf2ba3150" => :high_sierra
  end

  depends_on "openjdk"

  def install
    system Formula["openjdk"].opt_bin/"java",
    "-jar", "jolie-#{version}.jar",
    "--jolie-home", libexec,
    "--jolie-launchers", libexec/"bin"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin",
      JOLIE_HOME: "${JOLIE_HOME:-#{libexec}}",
      JAVA_HOME:  "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    file = testpath/"test.ol"
    file.write <<~EOS
      include "console.iol"

      interface EchoInterface {
        OneWay: echo( int )
      }

      inputPort In {
        location: "local://testPort"
        interfaces: EchoInterface
      }

      outputPort Self {
        location: "local://testPort"
        interfaces: EchoInterface
      }

      init{
        echo@Self( 4 )
      }

      main {
        echo( x )
        println@Console( x * x )()
      }
    EOS

    out = shell_output("#{bin}/jolie #{file}").strip

    assert_equal "16", out
  end
end
