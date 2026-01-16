class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.16.4",
      revision: "af7bea0b05b1c11d2579db02de3ccd32224b5ccb"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8af3de53188d33f02493d5081ef9279b2c04ad018f6abf75f69edebbbe8f2a00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dee007d8edfe16b4acdceb052c5736296ba3d7e10ed3ea3f9ae1ca961bd2e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90fdf528d831b557390b35d7b8fdd662539e9b644691b093ad094e4e0de4f3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "983b65dfbd7be26fc90026d85c420fa99edfb705216036f4bcf5990221f76fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6881ec3396fd2f214ca1c4dcd3f3fa29c66d5b48d3b99ad9fc70d7f501905708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b793c672f958d2b5d542b2691f12a3a72411dde3e2faf11b0e2bd1ba29de10c"
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
