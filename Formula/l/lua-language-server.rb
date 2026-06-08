class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.18.2",
      revision: "b5e57c36a9a27b89eb283861fb8946fa787e37d8"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8011cdc4f498cf886e3c41eceaf94aa9e07d2c59bae5ad5ed3f9ac27569f38fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d59af9f168232d0f7b070576623dfa1583653da0153a67a27445177be618c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411bdbc50150a4ce35d3e7e79d944d8d9ad8383313e7887a1a1fcace62bf1264"
    sha256 cellar: :any_skip_relocation, sonoma:        "f32fea9d978eb162aa812fd457282bb9cec6c20d2d3ec74cb1e0ff549789b61f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd2437196f40e7c199daafee01c5ccbf9ad9dd907fcd552fd7e133d6eca6fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109d59d4e1d6f7927a5072c0479e68a07c693bdd2e5a18bed71faa61b709d73b"
  end

  depends_on "ninja" => :build

  def install
    # Workaround until upstream can update bee.lua submodule
    color_h = ["3rd/bee.lua/3rd/fmt/fmt/color.h", "3rd/luamake/bee.lua/3rd/fmt/fmt/color.h"]
    inreplace color_h, '#include "format.h"', "\\0\n#include <algorithm>"

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/3rd/bee.lua/test/test.lua"),
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
