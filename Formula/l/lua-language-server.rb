class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.25",
      revision: "666a23e85707b73c22e02f620ad40607b18c4676"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d8938820174f79db955b5e8e961612a7722b3111153163f7336b7b21b6784e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2fc7da5b6f25a9edeb8f210db086ffe4bc6f4ea35f3c164036a9b7153f9209"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b853070e0a70e77721df06f27fdac6f0293cbed57d4f95e961a31effa2257a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "d0f65d6b8df662b16b97a326357e213cab3a04e6243ff536306c40c4c736985b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd27fe9e6f45f30cd807da0bd9b7c16438a62615034b4a4f0819a7c288125a16"
    sha256 cellar: :any_skip_relocation, big_sur:        "b071ddea296395dbf59248d5a225462f86ac7e8b457f323f8efaea1744224a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82ba23825858b42cb016a0ffc8302132c07516fe166c2a51afa229259a54d64d"
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
