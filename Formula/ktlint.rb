class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.43.2/ktlint"
  sha256 "1d74e463037a53cc72c601678faf672d2a5b0c2a96516792baa9596eab910faa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5fd1bf8b64e48fc322995ae098c1ed63818fd4d344f56368466c211e20c6cc9"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint",
                                    Language::Java.java_home_env("11").merge(
                                      PATH: "#{Formula["openjdk@11"].opt_bin}:${PATH}",
                                    )
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
