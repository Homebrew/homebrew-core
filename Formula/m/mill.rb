class Mill < Formula
  desc "Fast, scalable JVM build tool"
  homepage "https://mill-build.org/"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/0.12.11/mill-dist-0.12.11.jar"
  sha256 "567a44bee9006ac943f8cbec18c38637c544144726cdc699aa4f3584ed52ae93"
  license "MIT"
  revision 1

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56fc5b0defb92df981fa9e406356ed7138bb458cdfb00308c277f8d815c1219f"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env("21")
  end

  test do
    (testpath/"build.sc").write <<~SCALA
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.13.11"
      }
    SCALA
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
