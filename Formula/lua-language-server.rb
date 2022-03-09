class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.7",
      revision: "e3cf2df47f2201b6b8a45e1412d882260580494d"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0af5fb25af8c3a72b50f7371379fb96ca34971f6fc35650f0df5bec7b5c3b483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a506fc8d9c00e0fddc58efbfa95c5cd0107d0abfab8104d0d884a05a081b6d45"
    sha256 cellar: :any_skip_relocation, monterey:       "9bd5ca921813a1fa0f1f1f926f99e382d0b8b9e64cfbf9efa19b647e99e5e22d"
    sha256 cellar: :any_skip_relocation, big_sur:        "932ba58258230ecb86a42ddf74587003ea9843071f6718e9a9f8954fe90a63ad"
    sha256 cellar: :any_skip_relocation, catalina:       "680231598cf143eb66efa752ff38f6a8fbd000dc4e8ee0f09ae218a17f053fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7587e36ddfd990a45f4cc4183b551fdbf1a6d46c60c421a339cbe9735e6f4f"
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
