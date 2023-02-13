class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.11",
      revision: "21420c986d807a55e22dd9b4261c3e3279a19eb0"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e2817c6879e78c4bdb3be206c55f9ba7c5155cd62c5be3d9a781ad94db0a442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2956242790396f39696b7906ee1134dd4abd26ffe89f7d65c1df8a2677ce9474"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba7042e9075d052af562543d716c083e7abac8fbce6414b1de80b698ebf71140"
    sha256 cellar: :any_skip_relocation, ventura:        "506b4a4219da0a22e39e4f900ed45eebcecd8bd7a1acd48252323b91188f949d"
    sha256 cellar: :any_skip_relocation, monterey:       "c59a0947377e3a840c62b7cdffc0dff432fe9a60af49d1cf195e9491c6cb5ca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc599bece8a90168018b2e4416cb95e6d2425f48b8f4cb1194df5d5b925486ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be23d6abb3a017bd5875fcf4f19608753562b3a092ac70e769456865f5d43799"
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
