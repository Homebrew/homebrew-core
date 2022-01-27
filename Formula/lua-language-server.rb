class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.3",
      revision: "e9c319ac7c512b3563101c87d73d959931e1554a"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "febb1463ca79620f4e87856f62004175127921b47b36f4c967dd4bdb2bff8c82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "013b3b14a1f678930a3996050af673ee945b237508b18f7d4d52686fe41b1a1d"
    sha256 cellar: :any_skip_relocation, monterey:       "68d177a865842830fd255b67e7586c02424219113055fcd4fc90f371731cb23d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ca088702e666d86a8f5c6080ffadc5d7c664db414b45595c30f544d166c6bcc"
    sha256 cellar: :any_skip_relocation, catalina:       "f928528546558c4014009ae834ba51dbc56907c7d517591dc0760f45f7e5315c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dcda0bc179ea18539cc1f9b89edb8587255b7ca3858bd0aeeda43b656c09468"
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
