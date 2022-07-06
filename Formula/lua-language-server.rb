class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.4.2",
      revision: "f407cb07ed559daf7a5a943d8896e849791ae5b7"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d528febffbc98db1ab5e74d2242356de9833fdb95eb0caf52bc4882c2e7e917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c348e078ebecf5de76bd4f1f98ea51395d78196266ce0dd9145deea2b8ed6d56"
    sha256 cellar: :any_skip_relocation, monterey:       "9751f1bb8b61bcfd7ca26d29a29adde95bbefa0358da0fdef8308a21424f8a07"
    sha256 cellar: :any_skip_relocation, big_sur:        "08f72fe3c2ccd2def69473f30670888b4f1c99c3b6a6769d1771fb6f26fdc23c"
    sha256 cellar: :any_skip_relocation, catalina:       "8cf2aea4a862f3b88abbdab875b10aca5af6e49890588d1e83c5b16a20499516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574eb74d18bd814db67ca7f0ace819c4cba734653894f1e21d35400dd91731f6"
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
