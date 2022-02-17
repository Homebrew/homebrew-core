class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.5",
      revision: "76cc8c1807b5fc4fa583e1fb3217742a8f29559a"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf40a954537e9da9f00b61110b12f52e225bb0b89e154769590a845cf3f0931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e5d2e899333bcb73368cb6dc69ac5dc9639aa275e9c73ac4ad901f9b80bae23"
    sha256 cellar: :any_skip_relocation, monterey:       "a554aee0bf380d3e3d21fea34e10a6eee7863dd94b38137860582a30e723164a"
    sha256 cellar: :any_skip_relocation, big_sur:        "578f880b08475b10daf81be07e53fa5e2a9919ee9cc1fedc4b8353dabedb0029"
    sha256 cellar: :any_skip_relocation, catalina:       "675274c39c7149cec53aa1ac0e93c9155b41d1fecdf3cd417d2b1a315b385cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f1aa1a9bab38df2d199533acfd544cb6c8983899036aac68633c4f42fcb43c"
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
