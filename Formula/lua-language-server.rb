class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.5",
      revision: "3daee7053529c03834063ad4f5c7e0da971d5dbf"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf190e11578425a6bc1ad58de1396e05006a6364751deeb081e43b8d052fa23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18fde0b38469b25019526f25397f35ffa63feaa27b380e3d6d1a35649fb7fff9"
    sha256 cellar: :any_skip_relocation, monterey:       "39242f6417af48c48d0332df0fa60c001ba34c0ea01ab2045a09ffd96a6849ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fa06d646c6441f39c65982dc1a3c8d7be03e969f2b2428d71c0aaffb38d1435"
    sha256 cellar: :any_skip_relocation, catalina:       "e269df8923d13c36e9e9bdb8744eb736dd9d4b0d35aba52b016ef72df058b113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c05c31b23b87580919a22029fbe02c5743385239f7c7daa1a15e36aca702a3"
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
