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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2f697d0177f4655079df35dbbe751776dd124d602a0c282b0a412e9dd4ae026"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "172e8caa61b3a623150f42f414838c48c1f564b02ddd9af2dfce3745aec856f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1db29b531e0df389f657fdfa3855cb48ce94bb663176ec602ae8ff0053feb162"
    sha256 cellar: :any_skip_relocation, ventura:        "6bdaf35ad9fb17bdf685aace782bbf1caf955719d53b9a43bd2ba3cb9c77e1d9"
    sha256 cellar: :any_skip_relocation, monterey:       "08253dd73ff9b5fff382357a09f8f4c8f99c7fbf8040ebf2eff5ac8c62a5d922"
    sha256 cellar: :any_skip_relocation, big_sur:        "646cafba4dda29ecd09756bbe1687939ec7fbee40744dfa142b2e0c0974c2c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ff294efa8d8f83826ae3a37376b1ab59dd52119ed49f21f238d41cb4e48e92"
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
