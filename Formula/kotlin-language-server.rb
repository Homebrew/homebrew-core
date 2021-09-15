class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.1.2.tar.gz"
  sha256 "82d2a1c15d1384ff9fbafef43c54ffe91a17587310980ffb760c4d1ce608f991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95b7470967f113e4dcbeb374993828f401dcaca737ca3805b4dee6e231e619ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e2d8177c31a122d90111125fb7c97b5f4a4de8caad6176b4eaaf5eb244ee57a"
    sha256 cellar: :any_skip_relocation, catalina:      "dca2f2d46dfce5ffea6ed3b4bb33e182833035deaeebb7856b98aec0cbe86aaa"
    sha256 cellar: :any_skip_relocation, mojave:        "9551dce5fc05f035a58f2159d5ac3ad0553497de141b105e7233641f2a133fb8"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":server:installDist"

    libexec.install Dir["server/build/install/server/*"]

    (bin/"kotlin-language-server").write_env_script libexec/"bin/kotlin-language-server",
      Language::Java.overridable_java_home_env("11")
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/kotlin-language-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end
