class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.4.0",
      revision: "b09404bb037f50e5fdba9eecfe0e55c9e12faa6f"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f3982be0452e40a2d292b8d95eea0deda8e69409ff08107e4596efdf67b3f78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b817b759de4f6b97406b42f5c4c84f75477a2473a2f6eb249aafde53864b79e8"
    sha256 cellar: :any_skip_relocation, monterey:       "94c9718cfb89d75a48b06ef9272925d3661ef2bd990e4426fa36c3f2dbcc8937"
    sha256 cellar: :any_skip_relocation, big_sur:        "436b952e5ebff6c545476046f650289727f75b42c595451938d49c215f5884d8"
    sha256 cellar: :any_skip_relocation, catalina:       "f22b1c4b8bdf4052dc476f0b3a4017f0684f144ff5ca5d4bb798a8df52131e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b1c8a4eb0dcd3a33a930fe654b475a87e6d947671174b18b13097bbf0446ec"
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
