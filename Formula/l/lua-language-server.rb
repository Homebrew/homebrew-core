class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.9.2",
      revision: "f437ac3594cf56cbd6ce5160a03e716f5192e85e"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a37833ede58ae45948e049c2195091ded9ca89d29e9031f578a386496da02b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42ade3b0a4d3c80bb5cee427189056d2b662a6c7017f5614918ea93402471e14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4cafb430a18f84d7942900c1ed3826dd1d7a14471874a1fc9287298a512e9ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "40bbd29bd0fc2e5f2918a918d6f266391ec25b17267a607cc8ea443ec4c869d8"
    sha256 cellar: :any_skip_relocation, ventura:        "b7a924b6b92fe4eb7fbc70cb3f41f9c32b0e9a300241281ee7716eca96aa62a2"
    sha256 cellar: :any_skip_relocation, monterey:       "5fd952e52337832a18fe3f1494506430c846e9df8e651b55aee923519077eed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84a06063bb53c12fb02d57b9ee2ea15b198dbda647e4e2c6c2d6d14db0a12f1"
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
