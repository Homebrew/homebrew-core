class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.9.8/0.9.8-assembly"
  sha256 "0246eba6c743d17003f31916c83d74a7fd95898423c95abcc549dbad3546f7b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f3566d48b5acef9f7a349550dfe0a184b79a2bf4bbf70b0a3e2873ce9737ef8f"
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
