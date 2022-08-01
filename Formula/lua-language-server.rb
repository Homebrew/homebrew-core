class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.2",
      revision: "3b7b8b50acb2c0d6a2637269d34852e2bf43ac9a"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38f7dfc0e1f05383986b4d4fdfd30f575edc775d6525631669a1babac27a4c60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58f0a654e5b6919e31b6f9b18c2fb3c519e52b6205348f4c046f09484ca008de"
    sha256 cellar: :any_skip_relocation, monterey:       "8a4dbc23072bd4a6c23b28d0d099e5e26dfea95499ebb842822b49000d610ce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "906b0941faec4aaec81888504dbd0adfbca8131091c7bc37b3190d908eb6d9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "6072f601826667467cc03ad342132545f745f6fd066b682d2924bf1e46a4aeb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0eb1cfa7609fa4568cb20426af48441ab65544e02b9e27050625cdb86123329"
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
