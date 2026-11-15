class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://luals.github.io"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.19.2",
      revision: "b144c872f081373a893b55979142fed651e4425a"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e256addbc3a1385f5427c78691c2e1b4be4569c12adffa6b61ce0318c557f0c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14abaff25ecdc3f0682369270bcde3709c9130ce43e048cd83edde0a19b52273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51dc7f8ee13a0872712f5e1aaf78a6b9bc86396d933bd5f7e40c0c392406a8d5"
    sha256 cellar: :any,                 arm64_linux:       "369fd39b8c2e6eb1285e3a54a1409c1b91ec81526010ebe6ea51ff5f7b91a0aa"
    sha256 cellar: :any,                 x86_64_linux:      "45f61ac528f2beb3045c3c274e980a13f496f458c7f3a364bdcfeedb8a734439"
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
