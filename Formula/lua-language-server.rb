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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e68ae38c5889e83eb3d0dcfb66ad653df7b2a0936e4d06d628120b7044b4b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47a7e16e541e0866baeffa737364137d1cf4988dc5fb6fd2c0f760265d7f826b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88ea7fcb8479e8973f72ff59accc3079a3dbc0564f235397f56f7f7180181169"
    sha256 cellar: :any_skip_relocation, ventura:        "f16485fed623e7fc099a7ed9ba65212b8a4a66bc007651701051c404c8d05dc0"
    sha256 cellar: :any_skip_relocation, monterey:       "8280dc5ad04b8577c32b2acd7ce43fcb7bc15492579778611d1afc643f3007df"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a1beb78eb0d1b319d558e71553b1e5c8e6ac0c1b439680c50084eddea5bf0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17bb987cbc82d54cf4512e542933690dced32dd61a378896994a91ac611d67dc"
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
