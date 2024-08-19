class Jolie < Formula
  desc "Service-oriented programming language"
  homepage "https://www.jolie-lang.org/"
  url "https://github.com/jolie/jolie/releases/download/v1.12.1/jolie-1.12.1.jar"
  sha256 "d6d5f90254c43f04982451a49134e7df94a081a4d1965a95fc29e7959678a286"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9db417b509499bc5ff1b3bfff0d5fab4b6b0fe95185f8b0660615a2f04ab8c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9db417b509499bc5ff1b3bfff0d5fab4b6b0fe95185f8b0660615a2f04ab8c95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db417b509499bc5ff1b3bfff0d5fab4b6b0fe95185f8b0660615a2f04ab8c95"
    sha256 cellar: :any_skip_relocation, sonoma:         "9db417b509499bc5ff1b3bfff0d5fab4b6b0fe95185f8b0660615a2f04ab8c95"
    sha256 cellar: :any_skip_relocation, ventura:        "9db417b509499bc5ff1b3bfff0d5fab4b6b0fe95185f8b0660615a2f04ab8c95"
    sha256 cellar: :any_skip_relocation, monterey:       "9db417b509499bc5ff1b3bfff0d5fab4b6b0fe95185f8b0660615a2f04ab8c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6155fdd1b4c997e527baeee0af58255fc05402d8dda4b93c5359612da88f22d"
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
