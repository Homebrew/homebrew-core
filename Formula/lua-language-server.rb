class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.3",
      revision: "dacf711d57cddbf106937abd64f544a9298f3349"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5385de1d2cccd1ebfa49ea4bfa4b6995c73d23ec80bc3cd1ba4ddffde82d2b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e908e1dcd8f65cb1cf7b5f75a24c0937cd83e7dc94ab752de69e06860c2ff3b1"
    sha256 cellar: :any_skip_relocation, monterey:       "ad339f4be9725c9679f6881e72c1ffaf30aef389b6f3968949425d15238cdc53"
    sha256 cellar: :any_skip_relocation, big_sur:        "147a5d9ad2853493d9662413a752a88602b637671f2a50639d6e85db0433c385"
    sha256 cellar: :any_skip_relocation, catalina:       "87499cd312f3f75a73646e497023dca81a6a28788dcb412ed933c26fd5f86c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02b25ca6c738e0a463a886b910f304fbc8fad9a37298a577b75a60affce834a"
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
