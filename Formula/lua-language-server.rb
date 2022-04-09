class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.8",
      revision: "4d0e01ce2699e0fecd14563c42ad56131b89cf56"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb1df9e94e6752aaa80b125c00091a1a55614f5e94d26cbe9d4716f58c8bfc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cab84ae71f1f67a2fc235b9cfafa3e735014b7c44847490d9a2ea6d9afbe79b6"
    sha256 cellar: :any_skip_relocation, monterey:       "d5cc6fb44cb705269ced67d52b3121616730155bc33816cccb37546986f88aec"
    sha256 cellar: :any_skip_relocation, big_sur:        "157a93d65f5c794e2c10687c37b9afd233a2f74d8addd7042b871124c25c3fd6"
    sha256 cellar: :any_skip_relocation, catalina:       "3d5d4a150d19cb67196dc78bea5a443123950995b4116711a657354b56dbc3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2bbfdd250b1b84db1fae94ccdcce65156ffb79c8c1f217d599c2b3b0230629"
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
