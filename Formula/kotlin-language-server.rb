class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/1.1.1.tar.gz"
  sha256 "889a8866affe175c0c3fcd37b7a11e3f67b319ab3c1404d69c63b09a1796d3b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9e6d9feaaba28afcd3e8e472f24afab703597b863fff06c4986453457b732a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "2667fa432ee3189383e116565bd5d857bc996a7134991d5ff302769b4baf5b3d"
    sha256 cellar: :any_skip_relocation, catalina:      "24343fc079a65ec189c3ea2b97f6321ca5922cbeb62015971e6c16634e746bf5"
    sha256 cellar: :any_skip_relocation, mojave:        "44853329fb56e71e5b6670c2e7a018738f1e258dfd44184af9fc0e883bb46662"
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
