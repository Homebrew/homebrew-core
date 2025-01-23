class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.13.5",
      revision: "cdb1b094edf125dc537298cc408f8c751dcedf00"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d124e82c3c19eb7d1c740c05e9961cfc8f16473f829fdb8500a8b50cb1d6262f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1bacb2f7efb769e185a46dd4fe1d23d2a987cf0e4e9af0c820cb497bfcc640c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ad289e124bdfaced89c422fa7a946cee9088ae8816d5e9bfb6aa77f8c907d2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f134d6f0454d1b7336193ff52a40f260b046500c1d8aa5a985a0d65798261e70"
    sha256 cellar: :any_skip_relocation, ventura:       "e9ef286e3252d97af9af6c3ded1e1b2d4b925f95573e05c0b9799d6df998a171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6eaec93f6b7de2f167885bb449bf9bb87e3ea6ef0029cb97a94419dce226412"
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
    assert_predicate testpath/"service.log", :exist?
    refute_predicate testpath/"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
