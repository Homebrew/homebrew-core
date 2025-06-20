class KotlinLsp < Formula
  desc "Pre-alpha official Language Server Protocol for the Kotlin language"
  homepage "https://github.com/Kotlin/kotlin-lsp"
  url "https://download-cdn.jetbrains.com/kotlin-lsp/0.252.17811/kotlin-0.252.17811.zip"
  sha256 "0f38b00afb6d81f63d252dc729a0bc33a009befd11adea99001a52797d67318c"
  license "Apache-2.0"

  livecheck do
    url "https://raw.githubusercontent.com/Kotlin/kotlin-lsp/refs/heads/main/RELEASES.md"
    regex(/^(?:#)+\s*v(.*)$/i)
  end

  depends_on "openjdk"

  def install
    chmod "+x", "kotlin-lsp.sh"
    libexec.install Dir["*"]
    (bin/"kotlin-lsp").write_env_script "#{libexec}/kotlin-lsp.sh", Language::Java.overridable_java_home_env
  end

  test do
    # kotlin-lsp doesn't have --version flag
    assert_equal "Usage: kotlin-lsp [OPTIONS]", shell_output("#{bin}/kotlin-lsp -h").split("\n").first
  end
end
