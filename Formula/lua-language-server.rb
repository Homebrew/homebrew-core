class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.1",
      revision: "486a83603e0c0db72fcdfbf425c224ee76131cee"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "267ee5851d16070e6f5a930552878baa8ea3f9ea249e51c6f7cf672b25fd09ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d8ece6d72d3cf71504cc5c4d314cf2b016f014697ee86215cd5e8f6c8f6b6f6"
    sha256 cellar: :any_skip_relocation, monterey:       "de0cf8f9341cc5c1869c18475bed8d91c5c4d1a1f0e83077b28f156b8cc06891"
    sha256 cellar: :any_skip_relocation, big_sur:        "8af7fa1e75ad8c7ff68cc126d360ac38e242eba4675aeb1c02116ae90f37cd12"
    sha256 cellar: :any_skip_relocation, catalina:       "682e006cbea75692f673b988b27a2c07f78e8dd205c300dbd2f480d842a1b126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546345d5aa4617ece21dfcef31883a51c68803dd159e5924dc8689de891c166c"
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
