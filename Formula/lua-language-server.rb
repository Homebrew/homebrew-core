class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.0",
      revision: "be85f2c855f9075cadae3219f4dc1f3ce1f920ca"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b45583a6bf7863da9f1998d0736f61a959c058bef7ccd0275828c157382f857d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdb467e37002d6a784ab07cc47dc74bfe58aa0a7353b1153cdab17e30f9b132f"
    sha256 cellar: :any_skip_relocation, monterey:       "cd656632b6d97788ee27028d5ad5a77d513e6576c9957ee8385ee1f217107aad"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b188a8a590288e427462863a0323258401f1a261ed8cdc5730820565cdf244d"
    sha256 cellar: :any_skip_relocation, catalina:       "8da71698a9e7ce30f25e65304262457e1582e9ec6085da3c86179447503aaa9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46bc0808cceee8c304dada9fb3e9a79d937921cdd9b51b7b4645058c8bcce9c1"
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
