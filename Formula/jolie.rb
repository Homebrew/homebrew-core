class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.10.7/jolie-1.10.7.jar"
  sha256 "22e30ba88ddea7197843e868a2115edbfce6a871d7dc58ec35a34c709579fa0a"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50dcf57021a1915c8403e3596b6189dc435f3e8f286dd66d9efb3a5e2799cbe9"
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
      from console import Console, ConsoleIface

      interface PowTwoInterface { OneWay: powTwo( int ) }

      service main(){

        outputPort Console { interfaces: ConsoleIface }
        embed Console in Console

        inputPort In {
          location: "local://testPort"
          interfaces: PowTwoInterface
        }

        outputPort Self {
          location: "local://testPort"
          interfaces: PowTwoInterface
        }

        init {
          powTwo@Self( 4 )
        }

        main {
          powTwo( x )
          println@Console( x * x )()
        }

      }
    EOS

    out = shell_output("#{bin}/jolie #{file}").strip

    assert_equal "16", out
  end
end
