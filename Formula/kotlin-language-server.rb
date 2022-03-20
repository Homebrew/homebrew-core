class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.0.tar.gz"
  sha256 "679375e987aa7dea7dc8d291a1ebe729372dcd508065074c8b2d2663b6c776e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef1a6bbecfdc62410386d2f02acf4775806573636275434a41797d6921cd14aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "018806306d3fe124273bf9ea742ac848c67218f5343c989d0d931dc639bbe1c0"
    sha256 cellar: :any_skip_relocation, monterey:       "66407aa73f6db0ef7cbe35de4df502894ea98609cd23d43d6e058f8e29470fb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a693dbc67f8ab34ee7decce3237cdb6a3960f5d5e46c73f564ee70a325e6257b"
    sha256 cellar: :any_skip_relocation, catalina:       "aa1af6e2de79409ce1470619caf212960cad02ec317229248fa1f9147f5a5709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c74afd0401577513db5f79ed04c8903a1e36bac2aa3c3a8ca2a9b55c1a4ae8"
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
