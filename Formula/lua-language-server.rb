class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.6",
      revision: "75d4e9ec1a3df6c2a8d1a19eb57a26eb776f3624"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb1ddade03ecc67619628d33e9765a2b98a0f0d3156d21c54f61bc0aa09864e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a2fae212c5fa2ec80137713b09943a87cd4c1971f22eeb97b109e430fa8c68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3ffc7c93489141072d7096399afed494e6db56902d1bce3c3e384cb04f05f6"
    sha256 cellar: :any_skip_relocation, ventura:        "2934ce26121bde3c2a02992a198ebc379516923852f50bc8d9e837c04666aa69"
    sha256 cellar: :any_skip_relocation, monterey:       "31949546497833b0a90f0ffedb847eb16e8e6ca08dd9e621ba6e8fe22f40808d"
    sha256 cellar: :any_skip_relocation, big_sur:        "270b06f6a33cf381344777ab8c8a6e90a4c27b031bb69a16975a28d2ac00d197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dbbf062c83ba29e8f75df8aad939b8044e6c2a4eb132260c0f3be36c38f59ce"
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
