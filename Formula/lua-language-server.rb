class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.21",
      revision: "90cc228b936dfdcdf4a4dcf9cfd85d295bb71493"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0671b079654dbf277e0f9494d658cd92a6545c0be4439385b9bcf398a78f819"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db32f61980a978d5b9c7e3cef6830d9c1739e1fe16739fe7ce8b336739cd1bc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f99b4bc67444fc28c89fb02d8556c15b3caf9629167a0fdde7629039b03687fd"
    sha256 cellar: :any_skip_relocation, ventura:        "d189a7c2d91c3952cdfd30a2b8e1a317294f001be0bea07a7964dea4ba4a3501"
    sha256 cellar: :any_skip_relocation, monterey:       "2550a4d8c6c6a705e0a8d34cf9fc0048d8f6833389a947afb9c019618eb53939"
    sha256 cellar: :any_skip_relocation, big_sur:        "06c3200ac53345901b951c04e872cb6563457a1455e2c61059276b1c9e52a1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7352f7df22d1af170171697bb13925383b5bb44b731d853abf5adf38febd0093"
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
