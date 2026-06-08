class Mill < Formula
  desc "Fast, scalable JVM build tool"
  homepage "https://mill-build.org/"
  url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/1.1.6/mill-dist-1.1.6.exe"
  sha256 "37922ae8f8b49b4ae345d9b4d764be235c9afd8039e0b3fc513fdd758904649f"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64108c2a7cca7f1c6048c756c0e4b4f434223400200a2c6f619b80798ce4e3fe"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~SCALA
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.13.11"
      }
    SCALA
    output = shell_output("#{bin}/mill resolve __.compile 2>&1")
    assert_match "SUCCESS", output
  end
end
