class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.0.1",
      revision: "e6e46580d171ebe4a3feb390652f1cf42faeac9a"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "508cfeb97489297b1718ed0b8aaa3038b8ef2ac48ab5b4a654b47f5bf5753cb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f903481594bf9eba962fd501702353ccae3cbdae05eec2ea1e4579c0518d9aee"
    sha256 cellar: :any_skip_relocation, monterey:       "eac796927c08968b74816c47b031c48796aec9bfb58058e75515fb87b2c1a970"
    sha256 cellar: :any_skip_relocation, big_sur:        "c993e292d8a4383ce62b8c829040a7883a12b57ab44a079a8d0f6e55191e6d69"
    sha256 cellar: :any_skip_relocation, catalina:       "47aaf8d5f22542be3c133da6e15573349a539157ed9708070352e5dc3699ef00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18cf58a2b82dfc82f80dbc4cac862ed54dca34a4cc5ba025b7416e2c5aba0c6"
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
      "local success = lt.run()",
      "local success = true"

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
