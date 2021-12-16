class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.5.4",
      revision: "091be40543d0866cc37b10a4f76eeb2c86e4c2b1"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "addccad1068a5f4a4adf0b41b0d76a32cf2c196d34678d318de4ba4255d303ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2f79f79fdb294705822e661acc671968067718a1c18a1aedb416b174fabc821"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc9d155f33ee7578e2b5f1ae80e21e2c6e07aaff62d1e0694bd1064482d6351"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1112c927fc5974e17a8fb82e6175d3ca5b44febb59520a5f6f5f1627901cf2c"
    sha256 cellar: :any_skip_relocation, catalina:       "23674f079721d0fe15755396e9b82d15840469a5f8b4bda312445dfa222e5ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03bda04e74f708dddab1ae2b01a0560f8948e5ef06ec77dd26c344924dd1876"
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
    if OS.mac? && Hardware::CPU.arm?
      system "3rd/luamake/luamake", "rebuild", "-platform", "darwin-arm64"
    else
      system "3rd/luamake/luamake", "rebuild"
    end

    (libexec/"bin").install "bin/lua-language-server", "bin/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec/"bin/lua-language-server"
    (libexec/"log").mkpath
  end

  test do
    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/lua-language-server", 0)
  end
end
