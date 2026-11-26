class Mill < Formula
  desc "Fast, scalable JVM build tool"
  homepage "https://mill-build.org/"
  url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/1.4.0/mill-dist-1.4.0.exe"
  sha256 "ac428f34571e509203e2991f6d61b6de61a93dcaf484af5458a626aeb4043d81"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/lihaoyi/mill-dist/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    manifest_sha256 "182dc49a29367152698457163a7524c74a38ffb7fdde38f969b98f36f3120ad7"
    sha256 cellar: :any_skip_relocation, all: "49ee60f4014e88fb432166da28b61616e49aa129ee7a488b35d205ebe748189c"
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
