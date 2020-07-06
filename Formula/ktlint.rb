class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.37.2/ktlint"
  sha256 "1b301e7c6bd0b90f7541ec7ce118b497312bc5bcc37118ce33fe0571f7661ec2"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "ktlint"
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
