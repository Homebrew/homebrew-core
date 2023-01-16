class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.5",
      revision: "4cd472b94bb5766705c6062781a4d9c1908413e3"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e64defb1f3729347383366fcf22e4d61efb37cf5125d3b9d2dab82c48c0c3bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4da4edcd367b34879130de21d44616abef120f9eb13a965f3b215792e4f8b93b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47ead821a9276c553da43bb98a39ff064ad0dfb78e36a0f2c8c7b36bb82d4a17"
    sha256 cellar: :any_skip_relocation, ventura:        "b52fb5eec50a2ea3489125eb26c654b2e1cc00b9576ba1e64d6f1e5d25e3eb50"
    sha256 cellar: :any_skip_relocation, monterey:       "d886103ff531e14ef7f93a05471e635b316e1e5cb444f651dc162e0bb13226ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "a84752cc0c0240d0da8e6875a5fd9100a39710322f53276d76d1aa9a3eb9ab91"
    sha256 cellar: :any_skip_relocation, catalina:       "083ddc82334dcff3a92119ae2757b956c92f806eca12be494fbde1b50e080ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf03903c074fff39aae05c223f257d718ff36b09e109f78623189622733849ab"
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
