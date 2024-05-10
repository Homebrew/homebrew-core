class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.8.3",
      revision: "6b5e19597d88a219aac73cbccd6f88a4213e07aa"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a7bf03022ff209381538d58d1ac3c722551ed7f7f25ae351bdb8805edae2e4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bda2abb3ef0626a1dd97348b63f5130ac3e95b999ba315d06a7fb0dc7cf5789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddb70f6d8dfcdcdcd2b36cf44eb1498a7605f63f76f75991dbd01d3a8317771"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a6af2bd4a5c3ae770645a43f79848ab0c64660b04dca1f67a7c59a7a9a56b85"
    sha256 cellar: :any_skip_relocation, ventura:        "e667adb77db6e1fd5afa9b33e81c5577a037145b76b1ca167e855a6fb1926cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "b77331ead78d84ae1e3dc9cf23d7b923ebf17b997d94a56b2aff050ac4752dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f439899b5d17f29e1b0dec5fdafee8b89b1e0bf48e1642bfe6637535e18eda7"
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

    # Make sure `lua-language-server` does not need to write into the Cellar.
    (bin/"lua-language-server").write <<~BASH
      #!/bin/bash
      exec -a lua-language-server #{libexec}/bin/lua-language-server \
        --logpath="${XDG_CACHE_HOME:-${HOME}/.cache}/lua-language-server/log" \
        --metapath="${XDG_CACHE_HOME:-${HOME}/.cache}/lua-language-server/meta" \
        "$@"
    BASH
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
