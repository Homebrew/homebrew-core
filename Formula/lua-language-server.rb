class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.10",
      revision: "42f48c7777abe9243372688701f8609ce923168c"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8901fa884a1d8c8e3e0f2718ce3763fb17e07fdacb12aad4f0ff6705b16fc81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8efd4ddf04b7871c798eb176781cae45aa6ef0a48b0e7ac1ae1b1e76581f8f64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3654bdc6525e6371c68b765a5a04ad5a542ca4146596428ea6a76af15ff9660c"
    sha256 cellar: :any_skip_relocation, ventura:        "af97e2684c226c24f235858544d489f679f505e73ed126f595cbe171bb5ba244"
    sha256 cellar: :any_skip_relocation, monterey:       "c180905fdde784fc63d7affbdc1c66773c7d346066e75959639c7ab3e970d137"
    sha256 cellar: :any_skip_relocation, big_sur:        "03957f94c3f0bea7bc4ffc4947c632395f66b2d42a03719be719c96cbd8abc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa218f60795dbd9349979f14374f4833bf3292dadb6e1dbbd9dc4bc2a3c478ed"
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
