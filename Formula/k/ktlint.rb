class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.5.0/ktlint-1.5.0.zip"
  sha256 "3958a51ca45a82baf3d03aefd3ea199058d1e170df022b0c47605ef0c9a048e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "362b95a52606c0d580ff4937513417ca9996028ede7204b5869ab6078114786b"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath/"Main.kt").write <<~KOTLIN
      fun main( )
    KOTLIN

    (testpath/"Out.kt").write <<~KOTLIN
      fun main()
    KOTLIN

    system bin/"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end
