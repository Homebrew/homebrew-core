class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.3.tar.gz"
  sha256 "11d405dc6d499fdb6c6c6fa0b58cce83af936c10b47d96dcc459ef0df9d97401"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf99a91267d4a134f52c11f349421c211f16a6635645a8a0317d6fd6bbc9561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "040ccb58cd945d930e9b4f82c61f112b507088daa84a8c5ed2cbcb1519061e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "043173010ab473c51450df4bad41f1dde203cc7e4236935d220863a2a082cd20"
    sha256 cellar: :any_skip_relocation, ventura:        "4d55f1cd808cd1e0c9aa3aa080092f61033463186bdd465aeb631220a16e1357"
    sha256 cellar: :any_skip_relocation, monterey:       "d5406fb2155b3d1e7e6bfb8de885c24c6770fda1d934c5c79bde1074fccdcbce"
    sha256 cellar: :any_skip_relocation, big_sur:        "19941a5706422aa317aa632f88e8f163c1ad06c5a4236eb8e8508e645fc9b61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ff93fa5087d11852f12d15d921da00518fdd6f55fa80ac52662cc2e117737e"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":server:installDist", "-PjavaVersion=17"

    libexec.install Dir["server/build/install/server/*"]

    (bin/"kotlin-language-server").write_env_script libexec/"bin/kotlin-language-server",
      Language::Java.overridable_java_home_env("17")
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
