class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.9.tar.gz"
  sha256 "4c06ce35b1686c27cc4a8b8dc0905dd3901e83de7028e0c7c0cfd2b6082e1e09"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8d59892ad24d73ed974361ae1cf3d76a5b69be2aabf65ba957c613f142dfc0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e00c791ec11c67d1b7460aa2e1a7974540958f77e1ce3c8e58dd08a89b050a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "322fc2466fc81316599f83290d47d32ca34cd4a595db595c313b7483717cc444"
    sha256 cellar: :any_skip_relocation, sonoma:         "533bff6c7a0e79a623c818109e1afe6e189de0bb63e67fca5ba408a4eff2a402"
    sha256 cellar: :any_skip_relocation, ventura:        "d702b4eb3f92da0a827c3d5368fd7b60703579eccf493056e218096123800eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "0d6cccf5835831e9a4618982f35e0b33fa21b5a68f6e9087f1422d0718fc2d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4320f8a6d153c210c02aac4288ec8c2f9f77743f22bcc4093b39137232749191"
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

    output = pipe_output("#{bin}/kotlin-language-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end
