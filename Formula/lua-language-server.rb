class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.0.2",
      revision: "c4f70450e6727a693586ad7941581ac51014545c"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09865b4c7ea91154830b1e32d4d507ce7a0ede80fc209f1549a13b41a49be0cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "015a3169e0a69dcf902c4b3a5a4d54bd279c045ea10142f2e093c990025aa2f1"
    sha256 cellar: :any_skip_relocation, monterey:       "0fab3b265b468279e23c76717d6d52ec2bb84fa74cf35f042d41f28786fc6a38"
    sha256 cellar: :any_skip_relocation, big_sur:        "98405acf6de57f6f1d2e5844cc9c073cfcf039023f528a03346e9e8d3202ee46"
    sha256 cellar: :any_skip_relocation, catalina:       "67283633acb8d38e5ee7395a026d2c7c3c4a2fcf2a8cad2ec92fc338936cf472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbcf933698aca66b96583ab8f654b79866f4a6327c6ce6d1cb7d7012d339fbe1"
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
