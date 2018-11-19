class Mill < Formula
  desc "Scala build tool"
  homepage "https://www.lihaoyi.com/mill/"
  url "https://github.com/lihaoyi/mill/releases/download/0.3.5/0.3.5"
  sha256 "c869f584eeadd3a9a7a37a6ad1af6e0c8308b603b62986da2b28cb6d5c406aa6"

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
