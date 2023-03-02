class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.13",
      revision: "8da10a0819f11dfcfb9b4e00fecedb475b696e6d"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d0c02646c0afe21e995c1a85b328d0c3f96135db4cd8a3dd21ec82228141988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b5c5d9a42f4405aad1c1cb35273f1d2210dc66ca548c236335d0a729691cf96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4841ec71e2c4ef40a8f29a6fde55e80b96a0ce165ada52b7b2eb9117eae1705"
    sha256 cellar: :any_skip_relocation, ventura:        "93cf5f042ecda2294b70d1e236581f9b4180671d81763e08b2e23ae05e8f2575"
    sha256 cellar: :any_skip_relocation, monterey:       "25d6fd0df10c2ff7c9f8303f330d49d4f2b9dff96703ec6057760eb97def62a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a0883f28924839fea376a4d2b35e468890cb0f4104fb77685275080d9a2f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b81a54ee2033d00243885c756011ed58b0e204ad86709345993acc82f42883f"
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
