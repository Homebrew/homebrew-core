class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.5",
      revision: "76cc8c1807b5fc4fa583e1fb3217742a8f29559a"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "014cf74dbf1a0548101895657a1dd93e9cf39c6142a94029481469f5344ce098"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d4c684645c304c0c52911fd001ada0b2306d7e21f4c536af5e38429e0c25a0"
    sha256 cellar: :any_skip_relocation, monterey:       "39e64e8aa641998cc3fddb9ebb22616ee633b5f06ab455daf89d6e67b2ef4e52"
    sha256 cellar: :any_skip_relocation, big_sur:        "f57911ee923e54d9604f10d45c912f33d34bf20cd15c7344ded2d94945eb15d4"
    sha256 cellar: :any_skip_relocation, catalina:       "716cf60a65d50227ab11ace5aba4202f44145d97a0706642ac403915fa8ba5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b299bf6be6c37c38cbb41a225bad078d391331c601cd87da72bff903d5bd7ae5"
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
