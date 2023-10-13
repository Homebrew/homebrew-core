class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.0.1/ktlint-1.0.1.zip"
  sha256 "02af5dbeeaa8a6f14bf612c391976c6932c329502b3d3ada1c45d019dcac5ade"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9db2927561be446b6735170b019ade0b1fc6da406322c9aeac8799b5b65279e8"
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
