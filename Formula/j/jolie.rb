class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.12.0/jolie-1.12.0.jar"
  sha256 "67edee1780ed1390f8ffcc37a2342e95feaa819b20982042f53b226b9a87699b"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f120e4134af5b1034b44d3f84230d67bc70ad47dbc393e853a798388ebbd93b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f120e4134af5b1034b44d3f84230d67bc70ad47dbc393e853a798388ebbd93b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f120e4134af5b1034b44d3f84230d67bc70ad47dbc393e853a798388ebbd93b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f120e4134af5b1034b44d3f84230d67bc70ad47dbc393e853a798388ebbd93b"
    sha256 cellar: :any_skip_relocation, ventura:        "0f120e4134af5b1034b44d3f84230d67bc70ad47dbc393e853a798388ebbd93b"
    sha256 cellar: :any_skip_relocation, monterey:       "0f120e4134af5b1034b44d3f84230d67bc70ad47dbc393e853a798388ebbd93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7787f5b6977b4500ec51580f601eb4b5760a92b1b3ce730492726baf34c576e1"
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
