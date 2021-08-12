class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.9.9/0.9.9-assembly"
  sha256 "1c84fb6f1304cfb8e94ac62fa2137dfb362ec827ff01113b85de3c60c4e8f7fe"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8aba46cac8b9d6a9999370ac170a0bc3dc19d73dd9c35f64e199fc878e68b9d2"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
