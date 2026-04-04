class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.18.0",
      revision: "893236922450748e10bc2e62a666b6af9c5ff4fe"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf751fe76710eec9b82ad1ff80e2135bea7618cced05e099c227f82d94c7f6bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86adeccbe938be184ed26462dc3948e9d330b0dae3226d86f20d613c74b6b410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c161008bef134ff36b6b9db24254664c50d4e6bd4c56f865ae30b9670ab6cc4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c470d05580b39ea86ffb6facc4490ae7c930d4fd3bd9752de8e03eb84b4b0ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8137a1b93ea98a5887bf1203c88e4a5c701bd555fd5db39f0c79aec5b7387b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a44e62a0780ccf36068933c74c079d3c6469c432f8dd0daf3fa18a0c8f97c1"
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
