class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.3.0",
      revision: "fde5288aa33c1deadc0724cb2e9df2b628a310c6"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b65f19fcc03a39c2ee7d83af3dc37f919969b8cb12c22d65f27cc2aa43fdbd7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b68aa3edb81bf68f6e42797e26d176169dbcfb1fad239f71b8c393b05c1f8755"
    sha256 cellar: :any_skip_relocation, monterey:       "1a45cbcde717e2b31b5e582c335d97975b77658711ce2f38e8b4ca3e8d08b048"
    sha256 cellar: :any_skip_relocation, big_sur:        "a302d221a9383fd24c1041a72341628e88cb74cb224a71d847452ffbdc7ef916"
    sha256 cellar: :any_skip_relocation, catalina:       "00ffd29256f145360886ebacda614036c8f1add3d539c6e2185fdc2d03ab88b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fb822edd228db388a238f162a2a8198ad7a675b65a31aeabc29eb800c9ead5"
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
