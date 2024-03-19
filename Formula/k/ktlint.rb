class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.2.1/ktlint-1.2.1.zip"
  sha256 "a6d84ae60fa5fa3b0a40af8d9f88ec7a0de789a3bbd5515c11e629b1820c32b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09f8a9ea65773e77493c57d0433042d138dddda6ffe2eba0b8dab48c0ab1cfa3"
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
