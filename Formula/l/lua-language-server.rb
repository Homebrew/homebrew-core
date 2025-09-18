class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.15.0",
      revision: "32fec3cc99af8b9a1e45c2455a8c3bd0d3e38f66"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3102c7b726af1b7f76113a05912a1037b42843c756261660986fcf835323661d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4019f44924838952372d203004c67fcf986b7fce830908ce4079bf91309e23af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a7a14e2a40339cbd484b193d445f1f1a074d0d4e1ae4bf5ffb9343dd14bde2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d27ad9d4dd9e02140bfc7517c8154f0d173a826f667951b22492b4f482a8c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b6da52eeb2560147f73497d598509521a66f8530d30aaf156f64ca7b0cfb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec93281d45c0ec2e94cfb3f49d9d73c2247eed70ba64d6a7bedde1aac6e20ac"
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
  end

  test do
    pid = spawn bin/"lua-language-server", "--logpath=."
    sleep 5
    assert_path_exists testpath/"service.log"
    refute_predicate testpath/"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
