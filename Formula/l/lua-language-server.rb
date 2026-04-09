class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.18.1",
      revision: "088bc28b302f55db33e09ca283b55a325c918b06"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c14592bb02603e1e9533e2df45420e9c211b81aca6ecb0782f9093e7122c27eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028faf67b43d0e6cf61f2c8126d480d0ed258ccddfdad2bc795a9d4aac1a2292"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c80f232d06ecad2709efc9f994f1e5d5413253548bce0272783bbc75c5caa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d6ad760259a07744f88b4af2d50507b507b195a812608675c8137e53e43626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb1219eca784431003c0a18eb7e3aa68382e4721f4779a74fed9fb30c0962605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c613f51707317706e881579638a060c39075111ac7d09ca8993b7d359c9903e9"
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
