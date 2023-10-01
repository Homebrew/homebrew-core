class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.5.tar.gz"
  sha256 "df5fc81eee20dd46b24fc4284d3670487f3fe2d8d4ab9270031de2e41a819b97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "570f1087fa7ae48a3fff7aef5acc1bbd4c4decdedd4316d7d9b745eeed6eb484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a00ece273254080708a8a03e111a0ef4aaed2b6d960b7aacbdbd888d0bad77a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "868f60ab2bcda8496e305eb45902b244a249e7917475f5e99cf58dbc6e4c0ffe"
    sha256 cellar: :any_skip_relocation, ventura:        "c34802202a2f544c145c6af6938d82027962b3e0aeae856872f5418d7a35b527"
    sha256 cellar: :any_skip_relocation, monterey:       "b60acb09c93acb542c1dc59b3d99ab31b19d833f1ca79336fe5a652fc4419735"
    sha256 cellar: :any_skip_relocation, big_sur:        "2710a5e649593f52e0ffb38dc976ad26a7ed4751092795413efdd75c1d629f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d29c47355602db272cd66c0601ad58da335b3e4c94d7f56017f70c78dd9dac3"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  # build patch to build with gradle 8.3
  # upstream PR ref, https://github.com/fwcd/kotlin-language-server/pull/493
  patch do
    url "https://github.com/fwcd/kotlin-language-server/commit/622a63aefa827d69b841e0eb4a94375c02eace0c.patch?full_index=1"
    sha256 "ee7ff97d0af66a673183959d712bb45abf6bdd9b1233100390657b52a2bc147b"
  end

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
