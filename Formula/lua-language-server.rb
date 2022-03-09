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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4322f065a6e94aee07fbeb4eda36b4bf0f34db0c5db130353de3ea5ae662a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f26b28572b9a03ee7aac6707c24515a6f773a81e407599e2fd2e3f17aaf5172"
    sha256 cellar: :any_skip_relocation, monterey:       "429b217b3eed222f2db896f6aa282d822d502feebea0da51247cdee3dc45049c"
    sha256 cellar: :any_skip_relocation, big_sur:        "331f0eef7e1c03ec7e2769dbb8df062b4a41c0c2e9b7f63ae1a2043f8dddf58c"
    sha256 cellar: :any_skip_relocation, catalina:       "bd917346454b3a360fadbad62b86179e9316b6e96d1dd2b752cdea2ab8ab029d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5360d0ad0f8de5478952a8b6290eb5206df879a16ba7a5a59d63694538d69765"
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
