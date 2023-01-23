class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.48.2/ktlint"
  sha256 "68f7939d0b15b188e20420d6fad622cd9abb8a5f0de5350bbc1f2cd87830e216"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2fc86a4fafe80a59dc173d1d96181dcbbce71f894ae80fe366f703fab9c93e6"
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
