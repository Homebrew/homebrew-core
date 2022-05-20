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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5068d7103aa377605cc424cae4e6d3d6d293baff803e0d2dad8356122b3362"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f3c97d2cae6287c886ceafbad220b2d6baba8db4f87f0d01d96e9b355cee183"
    sha256 cellar: :any_skip_relocation, monterey:       "0330df0f7dc790c12d70befe8a3e3275af49dc6bc88f5dbab9058142907bc03a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dff57d08296c25c1dcd7b03bd229916e0db61558a4826e081dbf53830818c3a"
    sha256 cellar: :any_skip_relocation, catalina:       "878ac3cd440e1532294391179cf4c23c0945b79685001b7ce85b834daf55ebd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b340fad792243593ca76352dba68d77bc1ba39e3ed3da73f6c5a230f71ae2b8d"
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
