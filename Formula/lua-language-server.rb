class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.2",
      revision: "3b7b8b50acb2c0d6a2637269d34852e2bf43ac9a"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05dcd05236dd02142d39106136b62da81a6be327f87c3f64ef3c992d924947e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2789a28a1d3a1ae60c69488b45570500e384cefda8d38b5040f8aba27b89bb86"
    sha256 cellar: :any_skip_relocation, monterey:       "f7df1887cf02534c91c655236c94e012bffe7bafcdefd1e4c9ba7845b98d7a19"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dd9294b14d4cf2650a234cd2ea4d2cb3d51947ef270e0eba8ab222957517f3c"
    sha256 cellar: :any_skip_relocation, catalina:       "457b92380c36a6e9b5cc78f3bed8c1d21677a8b3645e1bff6aad3476e554381d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b609db6965f1b4b071faa09726ed6e37d44b6b85be16487b971de6cad4e129bb"
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
