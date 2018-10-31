class Mill < Formula
  desc "Scala build tool"
  homepage "https://www.lihaoyi.com/mill/"
  url "https://github.com/lihaoyi/mill/releases/download/0.3.2/0.3.2"
  sha256 "8b9ddaaf93ecaf1bec4a4d345a5b2018028b49cf30a8248de0ad19e13f176239"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.4"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
