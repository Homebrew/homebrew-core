class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/9.5.tar.gz"
  sha256 "85472c15590a2f5d89fc5c15cf1446f68c5e1479e2b1c2bd0e46a68ad1c504ac"
  license "MIT"

  bottle do
    manifest_sha256 "39b6ebf5fe550a0fad6da7a0155e8cfb0fcb6b7529cdfa8a28cd9ef8c441b90f"
    sha256 cellar: :any, arm64_golden_gate: "f6d3f91b369d6164ae9790583a44f4689babefa76591e297404836b9ea628ec8"
    sha256 cellar: :any, arm64_tahoe:       "8a9d866eb06823e9050d84a62a7c2de8dd08df3e552ef36a3e0b290c62d1b9e3"
    sha256 cellar: :any, arm64_sequoia:     "bf2359552704c3c04337dfb85bf3dc8d8e3038251fae8a6cfdddf0ffd7fc5c22"
    sha256 cellar: :any, arm64_linux:       "5bfcae205dfb51fbea9538c47642cc6371643f2b18160754b1c06b3b8c3c6fef"
    sha256 cellar: :any, x86_64_linux:      "66f41f4f0069b5dd62bb220700a81f263edabaf2e9756778ab872019a7566b57"
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
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v37.0.tar.gz"
    sha256 "3a0cf9fc9459ae0975afd1e24ea552decfcda2231651a0d3bd6e1f075e089e01"
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
