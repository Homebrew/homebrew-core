class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.5.5",
      revision: "4f74c75c6a777f17752178dea8e5a92179db86e0"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d5fb64d08974b3909bfaa2c264d7e87e1a38280aa8e538839b47b24df8172de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8caec812feb21019a2ec7d3255d027b62391a45cb5248e5e7c5a59d2165d5fc9"
    sha256 cellar: :any_skip_relocation, monterey:       "b295b2821601557acf87a8b54690b11c4c7f649138cb288d864d389045c699f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9aa6686d1f1b103c51845925bac14e8fe33a8a30fbcd5a748653e3669f5fd13"
    sha256 cellar: :any_skip_relocation, catalina:       "ab02823abdfa566dd39b2256833971bb72cb99cde4c079a9b4bce35623534e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0624ade46145a08af10801ad5a467a3ad9700e642eacc7b3c7c0873a18d7c248"
  end

  depends_on "ninja" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: 5

  def install
    ENV.cxx11

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/3rd/bee.lua/test/test.lua"),
      "local success = lt.run()",
      "local success = true"

    chdir "3rd/luamake" do
      system "compile/install.sh"
    end
    system "3rd/luamake/luamake", "rebuild"

    (libexec/"bin").install "bin/lua-language-server", "bin/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec/"bin/lua-language-server"
    (libexec/"log").mkpath
  end

  test do
    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/lua-language-server", 0)
  end
end
