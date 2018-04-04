class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.7.25.tar.gz"
  sha256 "25e963445a0e0ca65c543aebe288f9516c153320430b18ff1b734347cf309480"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1cc6eb5701c0f2fa28ba51763c17b39020aa2c1008319f26230cbe566c1d653" => :high_sierra
    sha256 "31724da87ddd9cf95abbdafd8531dba61c4b34814fad382ed90ec71f0495b379" => :sierra
    sha256 "07ef421f31b04c80368bb88e58f1e66c1225cd64fc051da192e03d22f25804ee" => :el_capitan
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

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"

    # https://github.com/TACC/Lmod/issues/361
    ENV.deparallelize
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use LMod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    system "#{prefix}/init/sh"
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
