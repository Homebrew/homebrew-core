class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.2.3",
      revision: "e62d964ff57cc0b37eb908315f9afe3ce6a213d7"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c642d465b0533acaa4ca3b6741238202c05c6658c13e164593a8b51777cc615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f89d1014d49308f7b136b2e81d25d56ecfdd27620805ef0abeefd2a41856d871"
    sha256 cellar: :any_skip_relocation, monterey:       "d31ad020518e65baa92b4e45e2b7ddbe71d6ebbe8dc4381f4bcb29b04fe91bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c01b82bd3a3944ff4325dedf4bf4c8ff37bc7ef3f106d46b5472d8035fd535d"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba96e87054902f909b602efdecffa38020076c95bbfd9c76c07fa7b18d76e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe50d31acbf04fdf56f6599f8893da5d259400f377b6fc9de2b2282cc44280f7"
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
