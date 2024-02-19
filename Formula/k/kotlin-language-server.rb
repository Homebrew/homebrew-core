class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.9.tar.gz"
  sha256 "4c06ce35b1686c27cc4a8b8dc0905dd3901e83de7028e0c7c0cfd2b6082e1e09"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa7683696d84ec4a485d4bd32ee5e8364a4230755a8a71b0b05d7070937d6843"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448e70081f23c2db25dea9b86cab775a219afb49a2190f4b975935be85b98b39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb73fd76ad3a811f76c3a464f431f33d71eaeefbd39c4e219b5c21f7869247a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6b565d76dc26dd9df38c5623778b9612479f1e0680ffb910f6262c552c9478b"
    sha256 cellar: :any_skip_relocation, ventura:        "f835c5f77b01d80f2f437a8cb9d2c04a283f1d9b972c447c38a1d390da146d5c"
    sha256 cellar: :any_skip_relocation, monterey:       "451bfd4eaeec930bbad53a02cfe982422e63c6e819765f628299ac4c1aa276c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbaf426c48685ac6d060d0eebaa2e8f0b0d5e08e52188e1fe0d8f773be96ca3"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":server:installDist", "-PjavaVersion=#{Formula["openjdk"].version.major}"

    libexec.install Dir["server/build/install/server/*"]

    (bin/"kotlin-language-server").write_env_script libexec/"bin/kotlin-language-server",
      Language::Java.overridable_java_home_env
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
