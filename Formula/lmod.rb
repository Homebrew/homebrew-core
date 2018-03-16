class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.7.18.tar.gz"
  sha256 "fe8905938d741fff02b7596b28fef26c311ffb807d27bdc1d83b185cc4d25fd7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e1a151373d5bcd70436936e901a668b705af5d3fc79a4378d30611daeff573b" => :high_sierra
    sha256 "c5cc588cf23b5e0c52a8493e04f5ab5bca38128acc121d04730c5cdcb3406e05" => :sierra
    sha256 "5b69ec947216ffabc421c33e357095c1b3a680b0821d6f9e8982632be605303d" => :el_capitan
  end

  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/v34.0.4.tar.gz"
    sha256 "eb6e7322da3013bdb3d524f68df4f5510a2efd805c06bf7cc27be6611eab7483"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/5.3/?.lua;" \
                      "#{luapath}/share/lua/5.3/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    prefix.install_symlink "libexec/lmod/lmod" => "lmod"
  end

  def caveats
    <<~EOS
      To use LMod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/lmod/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/lmod/init/fish, such as:
        ln -s #{opt_prefix}/lmod/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    system "#{prefix}/lmod/init/sh"
    output = shell_output("#{prefix}/lmod/libexec/spider #{prefix}/lmod/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
