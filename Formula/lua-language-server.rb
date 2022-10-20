class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.5.6",
      revision: "16f4d9c3269f54c102381d9fa44b5773c5b8c2c2"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf60717f1205defa9458c9b6596d87ad24a44f3460f97303d13e9c952847a39d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00397b2e1a6f7d0178c812c696d72d06dcda336241740bd4eca69701cc092b39"
    sha256 cellar: :any_skip_relocation, monterey:       "d413471bc0f2a4851666a5a482a9d4d56df026710d170e83e0055d1677df3cc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ad455d7f1a57611d089af6be6190a5e26a14615a056070b305426f26d772d84"
    sha256 cellar: :any_skip_relocation, catalina:       "7f354eb12bd9a3cdd5347801cb25d822cdf06943ded4e5c03874386f2d0691c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26453886185953bfc32bc6057d3e2bf974a5bff3965ab7b45cea5efb1fc633f"
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
