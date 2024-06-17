class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.3.0/ktlint-1.3.0.zip"
  sha256 "4c2cf93a1ba306edb3505b3333960752fe84896be4bd04134340c64fd6836f43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab5ea7ddd202c8591957354aa2b00f02484723f4974606c5faf7df780578b00a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab5ea7ddd202c8591957354aa2b00f02484723f4974606c5faf7df780578b00a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab5ea7ddd202c8591957354aa2b00f02484723f4974606c5faf7df780578b00a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab5ea7ddd202c8591957354aa2b00f02484723f4974606c5faf7df780578b00a"
    sha256 cellar: :any_skip_relocation, ventura:        "ab5ea7ddd202c8591957354aa2b00f02484723f4974606c5faf7df780578b00a"
    sha256 cellar: :any_skip_relocation, monterey:       "ab5ea7ddd202c8591957354aa2b00f02484723f4974606c5faf7df780578b00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35cdafa69435f1b3ee21627361b21a255f9528a633901dc0e709c92d491ca205"
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
