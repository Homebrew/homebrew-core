class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.4.13.tar.gz"
  sha256 "10ee1e6bf156b417bc822fe0ffd0692620f36f13b27f4f41eb21d1ea2ab8bc71"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1cd0dc6f650358282711fc82b7c10f1cdb1c9d348f9e9dc83d48dbe83067c58" => :catalina
    sha256 "575bba35b57256a677a5e58cef69f4a1d649f5647b27279e6a4f59dc07fe2a0e" => :mojave
    sha256 "f67941d48f945afc1d334919a46e6e2bfa4a4143a5720108a165449406d105ac" => :high_sierra
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/v35.0.tar.gz"
    sha256 "a4edf2f715feff65acb009e8d1689e57ec665eb79bc36a6649fae55eafd56809"
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
    system "#{prefix}/init/sh"
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
