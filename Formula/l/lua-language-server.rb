class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://luals.github.io"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.19.1",
      revision: "d11e79dc2745b5bfe654490eff234c6be2f6606f"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7b8dea25ad1d0749997294eeb31d98da5e85043d64fe9fa6381e55c145f6b68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d856c8709d98e4af1da64c12abf7575f02e336134838e91d6dbcfad730a9e8fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7fbab20c3e23c0c3857caedf5e3031a12efde0043f076dde2fc9f0465403586"
    sha256 cellar: :any,                 arm64_linux:       "c012324731c6b93866e16a64de709934b1dd77d56260704f20d511e4e1fe3eba"
    sha256 cellar: :any,                 x86_64_linux:      "16384ed7c7ecb71912b70f8b8dfbeb49547b81117be0eaa39d768e3ee462768d"
  end

  depends_on "ninja" => :build

  def install
    # Workaround until upstream can update bee.lua submodule
    color_h = ["3rd/bee.lua/3rd/fmt/fmt/color.h", "3rd/luamake/bee.lua/3rd/fmt/fmt/color.h"]
    inreplace color_h, '#include "format.h"', "\\0\n#include <algorithm>"

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/bee.lua/test/test.lua"),
      "os.exit(lt.run(), true)",
      "os.exit(true, true)"

    # remove git metadata from submodules
    rm_r Dir["meta/3rd/*/.git"]

    chdir "3rd/luamake" do
      system "compile/install.sh"
    end
    system "3rd/luamake/luamake", "rebuild"

    (libexec/"bin").install "bin/lua-language-server", "bin/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"

    # Make sure `lua-language-server` does not need to write into the Cellar.
    (bin/"lua-language-server").write <<~BASH
      #!/bin/bash
      exec -a lua-language-server #{libexec}/bin/lua-language-server \
        --logpath="${XDG_CACHE_HOME:-${HOME}/.cache}/lua-language-server/log" \
        --metapath="${XDG_CACHE_HOME:-${HOME}/.cache}/lua-language-server/meta" \
        "$@"
    BASH
    libexec.install_symlink prefix/"changelog.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lua-language-server --version")
    pid = spawn bin/"lua-language-server", "--logpath=."
    sleep 5
    assert_path_exists testpath/"service.log"
    refute_predicate testpath/"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
