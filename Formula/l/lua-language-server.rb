class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.11.1",
      revision: "db667f6db7ea6852d38460a1ed046eb85bb9e5ff"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef4f4ae1f31b35e99c730d8bb867e7f7ffc707440269fad4d08a2ca95101813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7775e3fe687c9a6d555ec50328c9d71711bf45a4dcf7bf6ba1200f6c628ef49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4a86afd5615228ba7c1a3379aaa671c4559d39963fe14334348054c5a0d0809"
    sha256 cellar: :any_skip_relocation, sonoma:        "987830dd3eae994596ce1024f1cd9db5bb71ed20dea11a5b4bad0da5998c5f3a"
    sha256 cellar: :any_skip_relocation, ventura:       "adc41bbf74c464f2dfbe441ec9785764d7887dc893659a4c749a699146528c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a82fe24c0127f224eb8707fc70f62ec99fbef449784c4215db32ea087ec2ec"
  end

  depends_on "ninja" => :build

  fails_with gcc: 5 # For C++17

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
    assert_predicate testpath/"service.log", :exist?
    refute_predicate testpath/"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
