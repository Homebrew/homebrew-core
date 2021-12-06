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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8598a4b0ad0dd5e5fb625cf3eeb0d67024d9ca0052f65df74c70c10ea719b111"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d1138364c82a2017a06117b06cb9a8284770cd08ee732a87feb14458dd849c1"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1bb72dcffdfb4fce07a8ed30c94c42a251418abe7ed7b16cb19f09c3af6cae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ba614b12c571a27101bafa7880daf07b27de32cf334c6fc8c3c3b574c9d2622"
    sha256 cellar: :any_skip_relocation, catalina:       "91fa44b1c50673e04679304570510d67e2db7b5467e9115d69d224330f2d58d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4af32c4c41f76628c26b4c19be9587ca4cbfefca64cbf7b91453b87c33e4aa"
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
