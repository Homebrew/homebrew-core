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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa6839d4c3cf588ac83019ed7bdb9862f66744c7e5bb07b3ecbc247a92e426ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00adc51fd5d33e3ab372b514c41a242a752273a505160cc53514414b32394207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c6a1faab397b6b0af923b15886a86013c489580e8f9d2d179d1fb162b44fe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b39698df5f5fe9987688a6e16bea5bbf90c9bcedb36725832c6e2e05484a20f"
    sha256 cellar: :any,                 arm64_linux:   "f0dd8f0497ed736c64fcd5201200d8185653f1866f9092bd8ee1fc5ccf6ba25d"
    sha256 cellar: :any,                 x86_64_linux:  "498127427c5b3b9fe0a3d4e56697b142ae4913b1b00a05eb0b75f028fc3bafdb"
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
