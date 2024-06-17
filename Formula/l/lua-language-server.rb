class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.9.3",
      revision: "2dfb12ad3759acb7ff47b4c5c54ad0a62c598b22"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09045a3dfe473dc9ec8a11d993256ba83332a2e0d810fda527ee34f77ae3806e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "352091ae25cf329ce6a64111cbb124f0110952d75bbbb0f11369b2fa420cbeb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e0d76d1f27e1189df3145b30518ece7068a83cf74fbc46a3ba786012443fb8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "da3d84870bbf2461e890c38ffef9b5ab66baed861c0af52002b2794be81086f5"
    sha256 cellar: :any_skip_relocation, ventura:        "0aba95a07236ca6a2b4fac35738427c8e2445050dc35fbf0ea9472347c8d0a10"
    sha256 cellar: :any_skip_relocation, monterey:       "bce06665199dbe57a218c088e285fb15bb840959e25401b7cdd825d2790989d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33c2309ea248ef5912df5046e7b3f2218182b01951befa3c612073b009eee92"
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
