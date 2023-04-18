class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.3.tar.gz"
  sha256 "11d405dc6d499fdb6c6c6fa0b58cce83af936c10b47d96dcc459ef0df9d97401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7f88c4448c48163f819235584d1a3b76268685e448adb077ecbc3436fb069f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13adf778e599d10d2831b742dfc2a46843d2b71335827fd5fd2bf94bb3e3ba4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "552e857fd4a653f244b942e3cc468c0a3da6f1e4e4de32a8cc559f47c93fc539"
    sha256 cellar: :any_skip_relocation, ventura:        "0a46448df3775c5d324f1f48e4b2061b25136f8816cbc90de2dbac1a0321ad59"
    sha256 cellar: :any_skip_relocation, monterey:       "adb8d9bd7b5e714fd4b61cdcda9762019363916e4d8f3e4b216a4340d8b9a1db"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d236ec9b1eea373ed052bec47af10027a52131a0584d9cbb7cd184326ecbfdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9db3e3b2d456c0d0002a4e7485e84c577bfbf6906c00df745a2100ed8e9f9a"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
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
