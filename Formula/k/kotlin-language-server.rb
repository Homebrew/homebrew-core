class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.12.tar.gz"
  sha256 "6d36c011b9a1f02f2d83570e1e03c77e2481a744ce3f6a7579cc83681f604aa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5e8892927c6542dadd2e505e3d05a1c23ad1c01733e7f9f26a3cba8ccac86cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e92605918e7da83a9e1dc913d204ccd74c5f4b8e9aac0cbae0768222203f2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b585c23e483af862f96b3e418616275c77f91250dcc9d6c0a10875c4d83574d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bb729d83ecf63175071e4954dff5b85f729893512018ba8e23a53aa20711038"
    sha256 cellar: :any_skip_relocation, sonoma:         "46bf3133b78b99e2146113941d072b7df3f846d69ba5763f9291fdc0624ad036"
    sha256 cellar: :any_skip_relocation, ventura:        "522688d61beaf748c5508e92fe4ccf5a2e349a4c3f47a5e456efba0231fdf72b"
    sha256 cellar: :any_skip_relocation, monterey:       "235497b217ef9cd30330ad18e3996ccdec429323c7ea3e3428e066b64d309e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fca93e17a9eba4a773f4cbb654369fe8103fa3c446d4fd9cc3cfdd831c0f18e9"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":server:installDist", "-PjavaVersion=#{Formula["openjdk@21"].version.major}"

    libexec.install Dir["server/build/install/server/*"]

    (bin/"kotlin-language-server").write_env_script libexec/"bin/kotlin-language-server",
      Language::Java.overridable_java_home_env("21")
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output(bin/"kotlin-language-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end
