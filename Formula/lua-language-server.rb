class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.1.0",
      revision: "076dd3e5c4e03f9cef0c5757dfa09a010c0ec6bf"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df968f48b57215c5eea7ce61f1cd7dd31852b1cf271951b4d8a6db72f0633200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7c2c772dbae2a323fda5a6578c3d95a6ff5ede339c00559c319c86e93b7a633"
    sha256 cellar: :any_skip_relocation, monterey:       "b55466123625f4ee741fc84e4ba25e5cb477333c1b66421b12a81feb2d92b11c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2446f1ad7174cde2d97ff1d586dd4ba9b115fad802b222bfe21cc442635353e5"
    sha256 cellar: :any_skip_relocation, catalina:       "0a72c5dafd1f759b1310594e4228c68a5881d7d67f6713c9ad2b99dbc9bc1d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1420bea6b479bb887924e59ccd284c11b4b634c7034b1564e7f403ecbe80fa28"
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
