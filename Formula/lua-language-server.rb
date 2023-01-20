class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.7",
      revision: "8da1d0d2158d73934b7c4af0a1e691fc1d58c639"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e33bd0c713cf9edeeb787292237e9fe01262da1fbdf68f8f6b7a0db922aa20b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f4425f6adfadaaaf2db497eeb67aae1aa77d4e7cd0a7f3d324158d9211bda5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed08e113f156991e09bc5e54d6f9173370aaa1719c6ea277f05d21062d8af542"
    sha256 cellar: :any_skip_relocation, ventura:        "f3b430261f73ecfe8c7d3ca5d94431f53c731dfcd7ae7ed14128420dee3067e2"
    sha256 cellar: :any_skip_relocation, monterey:       "2b4ea7e9b16c9b2991e416c08c0d24deb036408f404e5a7a4ce270d1f1a53506"
    sha256 cellar: :any_skip_relocation, big_sur:        "627a550eb3f3992d4d9bb9f785493fa5d3c27feddcf21da919f5a23c9ddf48c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84db812ab7267140a80fa4646b56659738413ee630e7cb97f23d1741ba2d8bb"
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
