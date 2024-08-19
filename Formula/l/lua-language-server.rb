class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.10.5",
      revision: "ba8f90eb0fab18ce8aee2bdbf7007dc63050381d"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74f7df994d4b3bd30589ab00fb86e2e6391d84a69230b5f22a2a665e19b4090c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50cfb357efebf86c0da6ac6b8c822c42a35397bcc5d1aac2320f87b266f87ee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7756ac690dd789676861a81515de3d9dbad2ecd07c1bdb78f6527f3bdba7a979"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc0196e956f31d1c300a7b59360d88ca681155f58e7c53246efddb56ea602d74"
    sha256 cellar: :any_skip_relocation, ventura:        "84b29ce5c28e9f3218d61227346487d8ed5a8a4bece8f05241ae8ffba564b060"
    sha256 cellar: :any_skip_relocation, monterey:       "25ff6b9776bf423893cf7394984f1a516d8a53a75549967e85d8fe5b82321df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0e93c01821ea6bb5638fdb8f51faee0509c92e5188cf6064ff7b4b5801910c"
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
