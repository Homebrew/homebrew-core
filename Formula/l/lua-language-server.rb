class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.14.0",
      revision: "485835e2a89004e1ffc5feb4484dc798a12af69e"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c24a86f8a6cf59821965f398d5c3d4654a714cfdd0544b6523408eff61b7f14e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcbb78953a2688a19c58da05b82ce658f551b44c2c729555582ee4c55d353cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9638941d4a7b086d993e351d8381e42bd8a70580816156fce52c551cef39c3b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ea319456b4e4c57b6c9f8e4f57c6d3b3f7f7795a4069bf6578dba33a7d56a2"
    sha256 cellar: :any_skip_relocation, ventura:       "7d65ee2d3dd4b4a48924d17094187d7ce96355967b407f48ea80e8a51efe4e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63a579898faea51de39d3193affba5adcfc965c44e005f0d33b1cc04690df135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc5ef22c1980bae8b517ef18f34e1b31bf6a5faa21ba4c94890ce716e3bec7a"
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
