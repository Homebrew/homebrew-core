class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.22",
      revision: "d95fe20a07d599994323a766c6f78e4867ddcace"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bae2f729fa997b6636f484cd2261628b119e8c00eb9670e8a38a65c396463a4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d072c639c597560073963d11b9c0f00a640321c949b2e3549fe7be8ee90b0b47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "628c8060aaad374c3c723f2c91c2118694c5a8292f73b2d3a90178bffd3ac71a"
    sha256 cellar: :any_skip_relocation, ventura:        "24b95f0f9e33c60a25b73fb87ae7e1ed9b0588e5db7d4b8c42cf60b426d1656e"
    sha256 cellar: :any_skip_relocation, monterey:       "d1eb5c24c7ec416c09631bad1f818ba0622f37ce5b039af4911a4eb182de0184"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e0db2373765b8e2be8eccb16603f0187dbcac9991dcfc952346659de027f7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a54460ee2ac32bd4c0db5e663267372c54b0a3ee47798a6fcf7e458061e65b"
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
