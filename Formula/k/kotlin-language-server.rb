class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.7.tar.gz"
  sha256 "a9144242b3892fe7f90cf800d1b6e0960f55829efd5e26cdd83c14344a53aaf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cd2932622fdeee42828c86bbed3dbd8f6aa576162b99c41eafe9bee59cb3a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36996d135368803626a1a0e5058b56f09ae30e1780c92d592336e1792c8dd3d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d79043f438ef11f1268c1e6642ac56023d282310bb8d358932c56e6cebf510"
    sha256 cellar: :any_skip_relocation, sonoma:         "321f735eb8702423da3758be3d2df63cedb3fb507611e5d173c637d6fca94458"
    sha256 cellar: :any_skip_relocation, ventura:        "18afcc908fc2f5cbac4ad65b74c123259a2b6c620548e9fabf7e1abd436a1271"
    sha256 cellar: :any_skip_relocation, monterey:       "b6affd67c7f8f636393c47bd2643e358879995f8e7ebe17307fb94de6fac1fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d7eb83275d0d3047a78843e217421acf0600d58db7cebaab82f3807549765b"
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
