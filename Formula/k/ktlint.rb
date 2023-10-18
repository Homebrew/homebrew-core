class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.0.1/ktlint-1.0.1.zip"
  sha256 "26efbbfb24e3c4f990636845b51e79b3fae1c57d11f2a88d14a1fdd96f3c4da6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89f032b664c5b7b3b4b2bf0d523b2a36a286e5f637cfaca8e149e285fb8b8580"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/ktlint"
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
