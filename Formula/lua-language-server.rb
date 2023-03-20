class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.17",
      revision: "79b2a72e143fdb9119e5db3387cd3deca27e330c"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4af130fb128797ffce36c3d40662c48e3f79fb39108a236b2e733aa7f2fdf3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c3605607bbde4d2518356044e152995f6c83b8db362fb8d6fda444834a4e028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d07ac4201dea117826d66217943c688f57c778d47508359270aee258e6f2eca7"
    sha256 cellar: :any_skip_relocation, ventura:        "e50ec051a33a35bd9c50066e3e01c98eff16636b2587245f6ce44b01f2cf7438"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9b76dbf17a2edbf1ab15b3ae3dd4fc7d896084605bd407a64c3e421e378991"
    sha256 cellar: :any_skip_relocation, big_sur:        "095a15c69f662f1591abdf042049fa1e5a3fa3344646da4439c93e265c9a9c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "589c5d416b2545463c6086adc9fc5ae818fad3c49a0de62a4dd75348c5a83e75"
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
