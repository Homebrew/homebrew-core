class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.50.0/ktlint-0.50.0.zip"
  sha256 "5674e08be591daf6b9248feed2e4aaf4626225be89430fd9f9fd0cf70ede51c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60dc1790cc9541b73d4b9238e1ec3f9119db2b29e9f5651e77e600eebacd8823"
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
