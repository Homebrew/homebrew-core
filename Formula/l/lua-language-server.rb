class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.13.6",
      revision: "b0b5c8f17fdcb6f8d6244eca48b8fc053e9b15ea"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e280d1f8713086df6a8fa0a44cfd6b233de847601aa175ceaa7f85af1b029df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a46792e92d9f4c188a4beb33ca030f5e173caa0a9d38da38531ee80c0fe2b6b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37c31a9469409981baa683328473fa5269ca6b82f3b71b6371ee9d857d88ecc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7d7a8dffe9d1920f9ab71f234b0add573c701b03dd090c8173f3c91ab98b2b6"
    sha256 cellar: :any_skip_relocation, ventura:       "bbf8d9bbbf8e4b29b1ac9b846ba71a32781366b6880e8b979724a95017442b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b059383f836ef6b3a554207c1d4ccbf7837fda7d55474b48acdc227c69bdcb"
  end

  depends_on "ninja" => :build

  def install
    ENV.cxx11

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
