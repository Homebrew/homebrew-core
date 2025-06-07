class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.6.0/ktlint-1.6.0.zip"
  sha256 "3d7b44230df2a71c17667b59a0d17e2e3658135f29dcfa3e72b6ed5c4d29b34d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "778789c98fd46753ea4176df0a91970a6739ffe1169de393ef5f03aa894801cf"
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
