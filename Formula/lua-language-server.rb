class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.6.4",
      revision: "6c4fe2e8360b8bee1a6e01d5578e5cfc8191c1ee"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e471128b38239c94dad3950f4dcb9eae3a48c1088834cd07e52b3beada06b68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8ba0c7e083aec35f7b3265d450b44e5756309bab9fa34a19995aa9314a35f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "14efaa99c228ca8e30cbfd51e21550ff5e1d61bb8f29c2cb91f4deaadb288d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "058c7989c140c3b8660dcdf6110b6a77bc84d6a1850f9443aa1a4a9d7b8c5c48"
    sha256 cellar: :any_skip_relocation, catalina:       "3655847d9dbc42a88b5b730f572113b677b80f629e1d129dbf467ee8a9bc28c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b494992c7f64684bbac6bd41f39dd79510bbb7a597565bed41390a6782d706"
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
