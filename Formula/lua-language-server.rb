class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.5.3",
      revision: "dc5ee0b01a9610389e275ed8ff0746ba78cdd367"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "addccad1068a5f4a4adf0b41b0d76a32cf2c196d34678d318de4ba4255d303ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2f79f79fdb294705822e661acc671968067718a1c18a1aedb416b174fabc821"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc9d155f33ee7578e2b5f1ae80e21e2c6e07aaff62d1e0694bd1064482d6351"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1112c927fc5974e17a8fb82e6175d3ca5b44febb59520a5f6f5f1627901cf2c"
    sha256 cellar: :any_skip_relocation, catalina:       "23674f079721d0fe15755396e9b82d15840469a5f8b4bda312445dfa222e5ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03bda04e74f708dddab1ae2b01a0560f8948e5ef06ec77dd26c344924dd1876"
  end

  depends_on "ninja" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: 5

  def install
    ENV.cxx11

    # Disable `filesystem.test_appdata_path`.
    # This test expects to find user cache directories under ${HOME},
    # which is not compatible with homebrew's build environment.
    # See https://github.com/actboy168/bee.lua/issues/21
    inreplace buildpath.glob("**/3rd/bee.lua/test/test_filesystem.lua"),
              "test_fs:test_appdata_path()",
              "\\0 do return end"

    chdir "3rd/luamake" do
      system "compile/install.sh"
    end
    system "3rd/luamake/luamake", "rebuild"

    bindir = if OS.mac?
      "bin/macOS"
    else
      "bin/Linux"
    end
    (libexec/bindir).install "#{bindir}/lua-language-server", "#{bindir}/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec/bindir/"lua-language-server"
    (libexec/"log").mkpath
  end

  test do
    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/lua-language-server", 0)
  end
end
