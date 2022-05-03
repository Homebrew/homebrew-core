class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.1.tar.gz"
  sha256 "7b271a6e8509174707154fee502ab18a059c3e3c9d4b37cbb3c930bdd5b75e37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec4bfd04b8c17345c2ee4c6c4a4324e9eb39932be32a9e3fc1785d7e7e661138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95dd73720c09ba0c66beb08aa7966c2ffec46db194b8561b4a55454de47cb94c"
    sha256 cellar: :any_skip_relocation, monterey:       "4a873d104b80dc5a2725378471b4c25fa1dc6a73cd3f145609bab93eb4aab8a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7a38c1123c9fb23805cb3ea748ab8f8d426364ac6ebb3b76e51efccca70074f"
    sha256 cellar: :any_skip_relocation, catalina:       "83399a3d7b912c8b0505d13f06dac83f0593ec5d6462a3d965e069c559855f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e295ad62a314a111cdbcb1264f8ed698e948f32290105dd05e02a8564ff2ec"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

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
