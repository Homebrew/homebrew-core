class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.48.1/ktlint"
  sha256 "c6f392e8b788d0eac4e58845d6ab2a19435f2a2c63c4482667688fefd809ca1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "642f7ff68b30f9ad4e57131ac71547821f9e1f5694fba28f056ee6c3d170ad58"
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
