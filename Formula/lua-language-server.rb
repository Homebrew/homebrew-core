class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.2.5",
      revision: "afb4f838f65d22443ccf30089b2f898fc9c55430"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69d4105882fc9e306408a7481d86b5de2f8232087c23027a86ee84a81fefa2bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3049ef267c15434f9477434eca6923e4d30dbc6666c16ec92d0b0ddad7b452be"
    sha256 cellar: :any_skip_relocation, monterey:       "101c2f867d11d4de94f61fa9430f0d36c60bc9b0dee2546a906cf84daa84c9b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a336692dcd4a5928d4bd6a81bd67977cbc9372aa439d4da73fa2c73de2c691e"
    sha256 cellar: :any_skip_relocation, catalina:       "5af9075c6853a25d51de6ee1e8c6a181f648cef84ae410e8110f305396cd80be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6426a0467ae5ec780326a5159c7bd99c53b6064b5931bd1934614793b7f1b73"
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
