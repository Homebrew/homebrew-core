class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "3.2.5",
      revision: "afb4f838f65d22443ccf30089b2f898fc9c55430"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfc10c4868697d462304ee0c2beae93e75c2f065d4a8f25f8d76afedb9eeff72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6663bb1ad3bc7cb12c8e00a8d4197f1ec1147ad296a705b422cf91d2c21cd1"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f7edef4f856cc303e3590c954bfd7a23c49ad4d66ac7b8cedce2b14521eb51"
    sha256 cellar: :any_skip_relocation, big_sur:        "352c3d9ebbc1e73befff0d1493933fbe7ce526a2250dd0d4dd9364048ba34e20"
    sha256 cellar: :any_skip_relocation, catalina:       "dfec9eee5b514dd62e53b02c9cbb79fdbc61c60a20c890015580d97f5fe23d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "491dabcd7578feaf817a221d2d31e9821ec14f3334b45a5bcb626027c9cf1a8c"
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
