class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.2.2",
      revision: "5933902449c992179a0958a7d401a1d970e874a7"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00ee08a366ebb42c25ba3e3877f8cb7ce620c4b6a0a117d8268de8263f81eb84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4375db9d65213dc97942b675e20d61ce62bb12e0f4e2cba42c19ae3b76b2acf"
    sha256 cellar: :any_skip_relocation, monterey:       "a37a3d120d36145ff776a46a1935b739ed86d7e36e9cc298047e50dd01e7a490"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d5ec7d665c5fb46a7411fdd9d4e4d85debd5d43dff3952acee36f8c37906e36"
    sha256 cellar: :any_skip_relocation, catalina:       "9c479b5731a200308ee48f6609105531db64e9155c262bea0987d5a7d1fc2527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e36e57e88629beee79aa975118ec2bf424cd0beb30d9cbfeed51c520e78bed"
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
