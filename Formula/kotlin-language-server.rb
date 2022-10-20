class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.1.tar.gz"
  sha256 "a968e0079787f1a6d2f46b4dbd49b2394c266287c8573097f71a14cdb794223d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad521214d25e1c4ca6f66cbbfb7b877de45b7f6aeecbdfeb3d812a35d2367d34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42be778c6f2825ec713f5a65a8ab55623b8a8b3ec1a8712bd30880f873e25242"
    sha256 cellar: :any_skip_relocation, monterey:       "cacdac3c30827ebdba6ec8ba7c3194467a43ac05b2fd4e9bc667ee78cbef2b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d49a6301254a3824575a106eb4b7cd87f4497851a17a1e8b8cff36162ac7300d"
    sha256 cellar: :any_skip_relocation, catalina:       "864d2c7571e16472b304581106e2d718cfe3e3df0924416c41a10f9a335cae49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b546afa467dea1abbe547c6caea4fcf34d79267eb83ec314465e07fe4fb541"
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
