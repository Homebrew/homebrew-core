class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/9.4.2.tar.gz"
  sha256 "30c9e29d6ab942a194e9c8f7c78430f4e26269d9439a68f451fe1ca4063da774"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d8cf46268e33319c0d44cc895c86b20f5b673202c530f1bc5cff29a9be9b989a"
    sha256 cellar: :any, arm64_tahoe:       "66a8e31693ec3dc1010118c8a939040c7cfeb98c3faa2561dd80e6d430e30126"
    sha256 cellar: :any, arm64_sequoia:     "1df555bae2204243bd6acfc5219abb7bd015d2f457c79f992a48932a4c5ac980"
    sha256 cellar: :any, arm64_sonoma:      "297bce9d86f194b5ef7d21d7ee9fa0abb64611e3a3587fe37c38665232d457a7"
    sha256 cellar: :any, arm64_linux:       "a03fab7d5dbcaa52d58557293cfa0403bade93aabc1222858c48c9ffd764752f"
    sha256 cellar: :any, x86_64_linux:      "645c0d250d04763bada4c68b37d581e20b484c2492224ff24184fa4bfee618bb"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"
  depends_on "tcl-tk"

  uses_from_macos "bc-gh" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    lua = Formula["lua"]
    luaversion = lua.version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        # Arch Linux, Debian and Fedora have packaged luaposix 36.3 for Lua 5.5 without code changes.
        # They don't use luarocks dependency resolver so end up ignoring the Lua constraint.
        # - https://gitlab.archlinux.org/archlinux/packaging/packages/lua-posix/-/commit/bc724ec92dc18e6496593b58561bae8742cd4fd4
        # - https://salsa.debian.org/lua-team/lua-posix/-/commit/b1bd0ec25be0599fbdf7b50fc2442b6874f2e51e
        # - https://src.fedoraproject.org/rpms/lua-posix/c/faa875d881a18fac9b9b277bac4bc72fdeca4624
        #
        # TODO: Remove following when luaposix increases Lua upper bound. Upstream is still
        # waiting on test dependencies: https://github.com/luaposix/luaposix/issues/394
        inreplace "luaposix-36.3-1.rockspec", "'lua >= 5.1, < 5.5'", "'lua >= 5.1, < 5.6'" if r.name == "luaposix"

        system "luarocks", "make", "--tree=#{luapath}", "--lua-dir=#{lua.opt_prefix}"
      end
    end

    # configure overrides PKG_CONFIG_PATH with TCL_PKG_CONFIG_DIR value
    ENV["TCL_PKG_CONFIG_DIR"] = ENV["PKG_CONFIG_PATH"]

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    ENV.deparallelize # Work around "install: mkdir .../share/man: File exists"
    system "make", "install"

    # Remove man page which conflicts with `modules` formula
    rm man1/"module.1"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}/init/sh"

    (testpath/"lmodtest.sh").write <<~SHELL
      #!/bin/sh
      . #{sh_init}
      module list
    SHELL

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
