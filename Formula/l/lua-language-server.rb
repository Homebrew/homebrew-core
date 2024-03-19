class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.7.4",
      revision: "34ff9d3ca730bc28879ab2b0c1a49f2c5480f9a3"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a38183bd0ccdf8412d93444c0a1a7a12cd7f3a1c11a8a7e4ac36358984d464f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "244756c236d94189b4cfed05e968f06c482acc1214bad6c6b41404e0bbf8d110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65314d6e4b3e8548cdb629603afd2b9e497cecf985c376d0f39635d289cf6329"
    sha256 cellar: :any_skip_relocation, sonoma:         "d60087d3680c6d7383753e9eee205af60d08deb4cc7b493c0e109d2f1d908e59"
    sha256 cellar: :any_skip_relocation, ventura:        "5eb13fd30838ab0c42213100d1307d9258b230aa4aa3cdc65408b9b3462bbb19"
    sha256 cellar: :any_skip_relocation, monterey:       "3361364d1abe42adb182b53ad56bcd102c0868afdab3d612332076a69445cf5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c589223d43934d9acfecc5e0c224e7db0fa148d1c8dc8b65cb3beb23f79ef427"
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
