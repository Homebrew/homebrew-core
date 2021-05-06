class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.10.0/jolie-1.10.0.jar"
  sha256 "d50c3ac2f5567c2fb04880bcf8466b3822dfae31c540dae1ee49a8162969bc3d"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "418e6d2516610113c2977ca48fc54927e30cea26300b6d6c62aa415f6e4e47f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "03517491264e7bdbdb6bc71648f1a8d654ef5a192af2c0233470808bf5a570ef"
    sha256 cellar: :any_skip_relocation, catalina:      "f8aecb9822259d55665704df3939d474d4c86de04979d4f8cf244a4cf2ba3150"
    sha256 cellar: :any_skip_relocation, mojave:        "f8aecb9822259d55665704df3939d474d4c86de04979d4f8cf244a4cf2ba3150"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f8aecb9822259d55665704df3939d474d4c86de04979d4f8cf244a4cf2ba3150"
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
