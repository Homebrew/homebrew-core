class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.4.tar.gz"
  sha256 "acc71d2c6cd1135b04ff03ebceff3e88c03b999afccfb887f26c1d84bce9a6b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5cd6b2f2ba486a089a7fafa9e797fe8c880649d26c3fb130d01c216a3d44bad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "829a519d71b278494da0af9cd217ec954a8a5b1d39851835999e1cecb39c05cc"
    sha256 cellar: :any_skip_relocation, monterey:       "71689705e176b2ed71ecbef0054000a1cb0ea95c34d21d575e6f58aa1ecd9050"
    sha256 cellar: :any_skip_relocation, big_sur:        "71ba5046c474001dbeca5c655f303b65136792aa43ddc05a542faca46e42257c"
    sha256 cellar: :any_skip_relocation, catalina:       "412fe715f66b105008dbcb018280a956e7c1d297595a4159387f306ac00475c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73fb79f62fcd8ecaddc22a27752163a3c656e32175deaca677dd9741e2c35fc8"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v35.1.tar.gz"
    sha256 "1b5c48d2abd59de0738d1fc1e6204e44979ad2a1a26e8e22a2d6215dd502c797"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
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

    (testpath/"lmodtest.sh").write <<~EOS
      #!/bin/sh
      . #{sh_init}
      module list
    EOS

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
