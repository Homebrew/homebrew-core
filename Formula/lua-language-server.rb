class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.0",
      revision: "2d1119fac03e102a376140006a3eb9c8a4c59e3b"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7aef599415fcdca892571d97e8369c0c4a8c8185a2a624874a58fc2cff98bc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03e33fc1fedd5ed8f4c06a6319f3bbd0192a722e4778821a372cc1ce11d5c13d"
    sha256 cellar: :any_skip_relocation, monterey:       "712d63df4aea65c0f116efb1f3df9b08fa5ff03e5116df3ad33a33e13915b4b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5418dcdff4123ce5761362baa47785831335111c31478c22b8b925fbd33515b"
    sha256 cellar: :any_skip_relocation, catalina:       "ab65794230ed9a76493dc95239adfc1179d1e7dc250c3401eed798c256df5ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1fcc8e1a4c89d036b4d3cbfc615bf518f4cca874619a6012614a879403b625"
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
