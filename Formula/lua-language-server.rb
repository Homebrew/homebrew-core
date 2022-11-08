class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.6.1",
      revision: "442da6b179af08d5c15ae1a66ea9ff37e627fc64"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a3bbafeaba1bd74fe1d0d0cd797a3f0020c99976c7544aa8ece7b1a3082d549"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0698cea482fded0a198f32b7ceab7e278960c1086e788c1eb6431948836dc1db"
    sha256 cellar: :any_skip_relocation, monterey:       "1f17f42dddc556819394318c0e43c236a84fa278fe969d909f6474cb5fa16784"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d946eea72de6eef183749e8d1375ddf1f6a4424c272650a91c4ae0fcf38e227"
    sha256 cellar: :any_skip_relocation, catalina:       "acf77e54472d9240c877d6fe3d8d9d160f1df4f0b67746fc8305455bbf9899fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be2a28743ad70947a28c2569be98e54a2d689f9ff558fd54d56ef392c5f47c7"
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
