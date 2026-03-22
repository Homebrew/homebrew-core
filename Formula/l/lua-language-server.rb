class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.17.1",
      revision: "0187ddf19f940d8b9b95d916d73f4660ec417471"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "343210c808436accc9ec883be989ecf7455f55ff66e4683fb4a0646b73884402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eec1827a7ffdfd5f81d57960dd1976be47e02df2cdba1941bb897de4ba309df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a2bcea7210b185df6b649ea4171dd94dab595beb0ed81e8d78280d059af134c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e0b2481681da2c86cff51304a9a2cafd2d26b6e549bcbfaf22b1892c007811c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c6c4ef67e0ed03ec9e2026eb8b41db5431c83f150b23e59ad9707809498bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44a10ed9818ad611862a647ca7948208bb5a6eb90a27023c52e3ed79b853b7e5"
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
