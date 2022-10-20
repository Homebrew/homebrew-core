class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.47.1/ktlint"
  sha256 "a333ad0172369a5cd973aea83e02e8b698c06a2daac6f32925da03049aa3dce7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3de99f3f3384e691e0f0b1b63ac0c206931a754fd1e21c1b799770cace9710da"
  end

  depends_on "openjdk"

  def install
    libexec.install "ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath/"Main.kt").write <<~EOS
      fun main( )
    EOS
    (testpath/"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin/"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end
