class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.1",
      revision: "0c4f94b7b4cc3f8776f8136e777634973bbc2ede"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42ebd69a09eb2ea6f418ce28b4909866ff76133085726c45a3dec8e53d46dcdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a9b9d9e70cac2d2693fa3b26b6e13a72e31d753faa6add1dd22156a66bafeb"
    sha256 cellar: :any_skip_relocation, monterey:       "7a89218def51959209c9e096b166d6a5de6efd229b6a4d0b4fd501ded36b3429"
    sha256 cellar: :any_skip_relocation, big_sur:        "6162c26d87b533a23438efa7dba7bec703c6f19760619c3239e4da07cf594a48"
    sha256 cellar: :any_skip_relocation, catalina:       "5f763834daf7e069a64e325da4c465bf4da984a2048dbf2dae9c8a6afe8b57ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6224dd315dd116ecbdcbee9180aba55ddb059f2bd0f79e92cc53f270aa4adaf6"
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

    stdout, stdin, lua_ls = PTY.spawn bin/"lua-language-server"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
