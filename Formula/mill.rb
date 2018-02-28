class Mill < Formula
  desc "Your shiny new Scala build tool!"
  homepage "http://www.lihaoyi.com/mill/"
  url "https://github.com/lihaoyi/mill/releases/download/0.1.3/0.1.3", :using => :nounzip
  sha256 "986d043021bee4f2f7a31d64cf441a5098e5e60d94d9f865416b797b3e1110fb"

  bottle :unneeded

  # Upstream issue from 2 Aug 2017 "amm throws NPE on OpenJDK 9"
  # See https://github.com/lihaoyi/Ammonite/issues/675
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
    assert_equal "foo.compile", output.lines.last
  end
end
