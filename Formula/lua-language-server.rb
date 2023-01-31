class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.8",
      revision: "ba8d6c611e3ce320d563d927dbb67deec7205c4c"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c1d5a27a93485036bf1433a6372d7af2f8855d2f40ef0c5e6741ed31af7dec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba261201b9a186110e7bb9ae6d3a5c5fdf5550974d77069d959921d87b23f28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3a8b389ed5ef1406964a473eb9b054d6a51f264ed5fa135221aab697cf70d55"
    sha256 cellar: :any_skip_relocation, ventura:        "a8d30bda957a7f5640a9022bdfffa1af236739979e3680a5650359dd6be5f171"
    sha256 cellar: :any_skip_relocation, monterey:       "120a568535fda8317522fc0b392dd03cc21aeaca1eb78032d367ea2972f57fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "62be56818a60d344a942a0ba9af3a0798fd03600d3d45605fc6324a0b9176e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c3671cea89d5dc0054432257544fe79685e02002b2342400bf572bfca31689"
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
