class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.0.tar.gz"
  sha256 "679375e987aa7dea7dc8d291a1ebe729372dcd508065074c8b2d2663b6c776e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0f5fea7e740c7a461b7618d2fe99f794211aeac8bf95c0b3276767e72e33d74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48f56132fceac7ac1513c336ea0a107deac456517b1c64c326d72a6334058b29"
    sha256 cellar: :any_skip_relocation, monterey:       "ec4179c0fb818e80405e4e7c42c9fd63d185b57ec8395f847ae81aa4fae1180c"
    sha256 cellar: :any_skip_relocation, big_sur:        "baf223002af8e84ff3b4b95e021282bcaf819a11bca14c80adc208a905b0054a"
    sha256 cellar: :any_skip_relocation, catalina:       "abe6ab5b194f23f2f4bc79b9f010e60e207bc603c11b18556b19b14a5a429fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ba039a5dd1d1cbee827e439dcdd102ecd3a665937faac51df192715282de48"
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
