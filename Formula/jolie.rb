class Jolie < Formula
  desc "The Jolie Language Interpreter"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.9.0/jolie-1.9.0.jar"
  sha256 "1510ed7f114909eb79670462571ab0734a5b01e57d26da6fd1cf9ef6c67eff6e"

  depends_on "openjdk"

  def install
    system Formula["openjdk"].opt_bin/"java",
    "-jar", "jolie-#{version}.jar",
    "--jolie-home", libexec,
    "--jolie-launchers", libexec/"bin"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin",
      :JOLIE_HOME => "${JOLIE_HOME:-#{libexec}}",
      :JAVA_HOME  => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
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
