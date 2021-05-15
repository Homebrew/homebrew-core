class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.41.0/ktlint"
  sha256 "438bd098e5e8acc966940480b025af7020bdaa66698c7d76042416314100e183"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e579a1c6a074922e7280071c9cbd87f1604d645b8a1b694b9ecc95739e95111"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", JAVA_HOME: Formula["openjdk@11"].opt_prefix
  end

  test do
    (testpath/"In.kt").write <<~EOS
      fun main( )
    EOS
    (testpath/"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin/"ktlint", "-F", "In.kt"
    assert_equal shell_output("cat In.kt"), shell_output("cat Out.kt")
  end
end
