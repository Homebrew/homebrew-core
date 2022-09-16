class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.6",
      revision: "16f4d9c3269f54c102381d9fa44b5773c5b8c2c2"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58f8f3490383ddd2443855e51ce530fd1fb2e96958cb49b193a76704f4d40c85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa62b718f07adbf5748c5cd19d52b577cd5e8bedffe7b19efb3a6664e1c9799b"
    sha256 cellar: :any_skip_relocation, monterey:       "41cca80e0b90f12d8a40e28acb41504d6553cc63f05f9f13493be3195a6e89ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ef1beb9b50039906b9d8952c22792ef3e8b6b0f384e3ef2493df9b936fda973"
    sha256 cellar: :any_skip_relocation, catalina:       "910316bc83a7d82ed9bd63eb2844928b8d463ba863dc47a097690c54a19c3a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e715b6048f7580f62eff01b34388619a95c51f7a9655ec91f75e21ca51d178d8"
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
