class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.2",
      revision: "9e61b29f8039fc7c41c792ad69c1df5d21e864fd"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1abef46752440ba2bbb771e3bd9897f5ba5813daa1fca08fef6a2ed514a46518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dae08c8eddf0668f6a88c22dab8ec998574a7ff246df99bda329df3b825d77f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cadb50aaec412d530d9e13e8835e0e9f5c2e7aefd9b4693134ea0e4c15b1a61"
    sha256 cellar: :any_skip_relocation, monterey:       "cb658caec365e1daec08be4212d931022f6df78e43616d614c53c9646d80b08a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8cf4f814d7c15b507a9b149309d33deced4afd11bc5c8bab0802fd8a07b456b"
    sha256 cellar: :any_skip_relocation, catalina:       "37cca03301415aa2d79f50a9138cd76796f151ac56dd39e217b0445fdd757bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d96c500578c72a66d6ba2c3c4b10e8b59a3090720c989e55f0c2c3984952c30"
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
