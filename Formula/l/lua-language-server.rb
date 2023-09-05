class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.7.0",
      revision: "d912dfc05636ca113eb074d637905f4b2514229d"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eee868e27ee4a091b72e6245cbc1cac4a6543de2cbcbbfc33c6a62f0dc764392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f7c9befde839be7de51d784e10e975b10a551eec57dfa678e8dea90a643bd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "036f70fe0f14e926932df7b3339d5da5e416988f914fee83938fa0f9eb70d8f9"
    sha256 cellar: :any_skip_relocation, ventura:        "40a12ac0dd71b7ace79fcd5bfa739710bdd1b0d9909d7ba2e9df4439de857645"
    sha256 cellar: :any_skip_relocation, monterey:       "e3b36c93e38c6ebaa0fa9811cc6fb9345275274613d043a51a335d3bf55ffef4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c151d26800f775db2987792320fbc4b004048723cf7d17709ff36e7f1b386a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3301b708ee21ffde3628f191d7836eedc679dcbda1caf28c271a8ce132cff49"
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
