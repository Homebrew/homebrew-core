class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.12",
      revision: "b5187993b553d11b89c9dca70f509cd45a4b7f72"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc63b828f0250eadd90f7f82d81bbeb6619d7c8abadf75653c62171fa41561de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67dd0bc652660120e2ff94d57a36fb828294cf9b3beed389b953afc115742abf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ccffaef3cf6f67d2d38042e20398b33a42c6da2f1cf65b353194bffd474880c"
    sha256 cellar: :any_skip_relocation, ventura:        "1a0af0f8dfbfc5183d530d285ee4f903d334cf8ed72981d69a0fd42b1577f937"
    sha256 cellar: :any_skip_relocation, monterey:       "476eb6713182221a79ddfec0df4b16710d78ed17b4209fd05da8f2ed6103acdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "edd4fd323f1fa745da2ecbee082a6e94d82fa5a09ba39521373774ff62a76bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9939c071a5e4ee74a20e7c9027acbdd79a024b17d9ceda880e3a15712b2f0fb"
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
