class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.1",
      revision: "442da6b179af08d5c15ae1a66ea9ff37e627fc64"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08b4dfc4d67b123b4b4e1e36ab6703a08c7d9550cb6f68fc8948b0a91b425d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6d652fb245d9dabd15dba8f92cadf7ab01d63aa6c0c1eccaddb3743b41fc6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bedae35691c06ef436eb132708a00a3b9db036a08b74163301365546704dd3ce"
    sha256 cellar: :any_skip_relocation, monterey:       "1ba401e3d93463155e77daad0513548a1677bbb0114b77422c945c7969d9fc7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d5a7d7a329faaf41f049fc60d9698a393fa8919e99fe26d2584e70e93f86224"
    sha256 cellar: :any_skip_relocation, catalina:       "8066b79402b42ba24423cb75c78da6be2ad7dafcd4d593b5c7d1954e9affb2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3adfdf363ecc3ab76bd2f78b0b713c8a0b4cc6c9703ba58956316ec5911c8736"
  end

  depends_on "ninja" => :build

  fails_with gcc: 5 # For C++17

  def install
    ENV.cxx11

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/3rd/bee.lua/test/test.lua"),
      "os.exit(lt.run(), true)",
      "os.exit(true, true)"

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
    require "pty"
    output = /^Content-Length: \d+\s*$/

    stdout, stdin, lua_ls = PTY.spawn bin/"lua-language-server", "--logpath=#{testpath}/log"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
