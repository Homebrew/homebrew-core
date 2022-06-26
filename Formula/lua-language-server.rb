class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.3.1",
      revision: "6fbe324f7130c94046ce14eee2235b663b47eafc"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c185c6bf8cf4c4e04695f87a05175c95e8a93a718476f6f94720db302b4c51bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6661e51cc9a23569b1c485397264b247004818f74b5530fcc7727f2220d491b"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ee5d0ecdec7d6adf3bba4c2310dfbff54f9629a6c9e3427984ce048ded4f56"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6922352102336fd414e2e3ed46a1ab558a5b57741e42121deafca5c36b1def"
    sha256 cellar: :any_skip_relocation, catalina:       "f97355dbbc6352ad31a9ff965f41ddcbab24ba47ed13d74de4c8aab85aa535d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd8be6a131d5e2f7ce162a4fa4fde76d98550898e222d651dcad6521794f319"
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
