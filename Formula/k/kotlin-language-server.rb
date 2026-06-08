class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.13.tar.gz"
  sha256 "4cb346f989ef114f6073cb9401968a7dd27eb5cd96993fa6856203610a13f96e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82192bd12da883553702631b7bc43af82148f6812cee104f5cc2f1c89058da7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8f715a1cb3d08aba2c7691f832a7d7f080a456b31b7ad27c319e82eaa7b276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb973d9967acd621079bc932a5ad6bf2971020a9b2c75f4f4c2ba56d3d51157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70751b17fc9cb655dfff1b5d05c18bdc2ee8de66a41fbc5e9d4882cc0b13b3f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aa692e029744e16e952cf8de40b9dfd63f19416e9d5532445cc038745df83b5"
    sha256 cellar: :any_skip_relocation, ventura:       "06b601dfae36e4909787d1c2f9c01509c4573eb5a35b617806cd36faaf6c3bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68f9f6eff3f823259f8fdd3f93272ac79cdccfc4e4e7b5586e148b6302899a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b0bc6b824959b614df4e0cc31463ab4d8d3a95030c11dd9263921e2c5c5325"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21"

  # file permission literal patch, upstream pr ref, https://github.com/fwcd/kotlin-language-server/pull/611
  patch do
    url "https://github.com/fwcd/kotlin-language-server/commit/a788e5f7b449dd701adc642c7cfb129f1895bd3e.patch?full_index=1"
    sha256 "cc9f6c68a09c76017099ffdd9bfe242a81b51221131bc33f3a7e2baa5bea6d01"
  end

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
