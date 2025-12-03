class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.16.0",
      revision: "5f1226d0c06bba55684db0779e048920d64f1dad"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef7f4b3deddd4c769cc560e2d83b0f77a3cbb3a8962a0d59722d5a585e898ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2db5d06db488201ce9e000eed86dc15860739aed1e472009e131f541c2bb04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8084051b1b309d0185e2470f861e9744c615f7eb0dffdccbdfaaa467bd889eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2b24818fe3e60da52a1f6139457b2f976805d526f74857e658512e63ce57e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b02e69dcb139ed5472e7f897aa111328bee55968e541b51d2459a4ea2e5428e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91928c7baa9ab26fc967bf5967fa69918dc20038990762ddf9900032da51913d"
  end

  depends_on "binutils" => :build
  depends_on "ninja" => :build

  on_linux do
    depends_on "libunwind"
  end

  def install
    # Workaround until upstream can update bee.lua submodule
    color_h = ["3rd/bee.lua/3rd/fmt/fmt/color.h", "3rd/luamake/bee.lua/3rd/fmt/fmt/color.h"]
    inreplace color_h, '#include "format.h"', "\\0\n#include <algorithm>"

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/3rd/bee.lua/test/test.lua"),
      "os.exit(lt.run(), true)",
      "os.exit(true, true)"

    chdir "3rd/luamake" do
      ENV.append "LDFLAGS", "-lz" if OS.linux?
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
