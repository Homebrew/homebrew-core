class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/sumneko/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/sumneko/lua-language-server.git",
      tag:      "2.5.6",
      revision: "913b3b45af8c41c95515756602f8dc8ef46fe748"
  license "MIT"
  head "https://github.com/sumneko/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c932ce3994cbf0ca2d1eb919e7d6ba5986d4da0420b120fad0df2b50a917360c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8c23afd7b1411e86693a9f40b8a91735f03efbbaa002b6450e81dc9815c4062"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ff428c4458b08128947165259399452d23624e11484ee84e0962dfd0f70a2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "193318afed467e7588842d6c6566701e0d9ea477d40759568d1b9ccb9904cd99"
    sha256 cellar: :any_skip_relocation, catalina:       "8c4260e2e4ad3cd0f6ea88a5c14ef7009fd3aed29a9c35826d8564525149d861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2637bc6f5708012436c82ab8f084a83b1aade2ef37dc2dbdad029bfc601e68ef"
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
    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/lua-language-server", 0)
  end
end
