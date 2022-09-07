class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.5",
      revision: "3daee7053529c03834063ad4f5c7e0da971d5dbf"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44cb01a0a9f66e223f2ff43901af32ba91b32035e2b0e75f9ee0856949e91029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c17a2ba2610f40265fbdb113166c61fb14d9f334eafe5fe7d405138ec483bc3f"
    sha256 cellar: :any_skip_relocation, monterey:       "60547cfcaa9db3de7448c35eceb0d704b3222f300cbad54e0516e73820820965"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2bdc41974c0c4b81afc800b722e5cc006dd2c96dca346c0bec86ae750e71c9c"
    sha256 cellar: :any_skip_relocation, catalina:       "03801f5209d998eaeb8e6ddbb95e2f394aacb20613d3dc7e1c6a5b007f3fd19d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e652b71a78bb3db2d08429de0e37301c70e70a912f0b30d61c313f6faa113f3b"
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
