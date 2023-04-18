class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.18",
      revision: "50f77465af5ded634fd7aef07699cc4fc1c704f8"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a15948b2c4ef1ff34b9a247b0d36353bd9430c76ab56ba5780b2189d99780ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada2f10afe83c424fa07e7394f56b5798d1eb8faa48d509e300b59d72b8c25cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "825c8b653d17497bf23d116853080a4a7607cfc466489bac970207db8a83e301"
    sha256 cellar: :any_skip_relocation, ventura:        "bfd746474329cffbdb088e0506c0940d9ebc5c0ae9b3765cf204555ea71e530f"
    sha256 cellar: :any_skip_relocation, monterey:       "9773c2eaee74220b3828ac2e53233ce7caa5c887f0872b189bdf8d197156d477"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6c2a22bcd14d2896dd08ce9dc47fc4eca9b784e30a0d87ede20dc5c92b92ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d05ce93108b1e1b7b2197024a829dd9bbb5683f0a001351787b4efebc3fd2fa6"
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
