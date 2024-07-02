class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/1.3.1/ktlint-1.3.1.zip"
  sha256 "8f9a1cfe14dd9627e8cd647ad111c1bc2639969cbf1297511a6048e369efac3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b61e1e5292b6c23a19b0fef5cb13b2122718fcef1fadaf616cff6865db698ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b61e1e5292b6c23a19b0fef5cb13b2122718fcef1fadaf616cff6865db698ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b61e1e5292b6c23a19b0fef5cb13b2122718fcef1fadaf616cff6865db698ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b61e1e5292b6c23a19b0fef5cb13b2122718fcef1fadaf616cff6865db698ea"
    sha256 cellar: :any_skip_relocation, ventura:        "def9274810a1dab1d90b065e5e5fb6347a94dd7379fe6fd077a73f613ca842b1"
    sha256 cellar: :any_skip_relocation, monterey:       "4b61e1e5292b6c23a19b0fef5cb13b2122718fcef1fadaf616cff6865db698ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f7c80e7a124c6aba2f2695d2b38aa9845512b23ee153fc45b917cd5d7dbab8"
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
