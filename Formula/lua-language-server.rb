class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.3",
      revision: "09c4ae6d4960fc4ac93e202a8419c8b0a2d7a477"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6baa48af7ffce521593c7fb7f70218bb24665c9a0f5d256ee3ef1fc806609b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e0262bd5b6b33a7b3ebadabb15ef305279142ea4ff0da16a4f89b631b5d4ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c841c6c6b83af1682036267c434ba31729b2e2d0488018be5f6b98a7ac29400"
    sha256 cellar: :any_skip_relocation, ventura:        "38866b11ba2a4dffce501e8d68eaa0e6e5ce6c2d01ef2df479cc029f86c296e3"
    sha256 cellar: :any_skip_relocation, monterey:       "9237fc2ae9029088e99d70897d71fa773348f40d84bf6f2cf8d11725d8e4bddb"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf5030eabcf989979d84fb697547dc3f008f6893c2fced2ef4a825fa5a5fec76"
    sha256 cellar: :any_skip_relocation, catalina:       "0ba91ba15c68f7a33aefde0dce543514ee9a64f510ba0afded3ccd73c472602a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1c1dd54c79c3c9a7b7ebbff1955237c0c274d25b0fb31fe3f1a7615c219fcc8"
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
