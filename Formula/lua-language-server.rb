class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.2",
      revision: "d5b7d8f31c8f3325e8d769288000bb965f4ea35f"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e6d21bd689d6cfe0913c5d3834fa8e5436d79ecbeb4e094c42c5b3930e2608"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b48a9cfa5a348b72541b705d481a6e10cfdd0fb95dc350ed84459408691abbb7"
    sha256 cellar: :any_skip_relocation, monterey:       "0134845171864d6362dfbde6d3eed6e19b44810ff51da8ec846ab50e6956df49"
    sha256 cellar: :any_skip_relocation, big_sur:        "21132d5801b0c26ad90c8ac9a0c32b31c6e613259363c91199242032f7460d6b"
    sha256 cellar: :any_skip_relocation, catalina:       "214cc6a5c53f211ab9a188ad9c4514c6baf94a870bdf746c186e1ca7beb1fe08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ae2b96e645dc24db058e0451e676124d311ad5ec698a1a5a378d1d979a0a51"
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
