class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.47.1/ktlint"
  sha256 "a333ad0172369a5cd973aea83e02e8b698c06a2daac6f32925da03049aa3dce7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "017fc6bb39413ac029b64af8e0ba20c89f7e5a8f1779653a534f93d7ec0af36f"
  end

  depends_on "openjdk"

  def install
    libexec.install "ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint",
                                    Language::Java.java_home_env.merge(
                                      PATH: "#{Formula["openjdk"].opt_bin}:${PATH}",
                                    )
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
