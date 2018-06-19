class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/7.7.35.tar.gz"
  sha256 "72f7964ef6fa6c0636bffeaf5d99d5d84b3564cc8184d2851afca585ceafe9a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e450e3e7d31a4e65517a23cb788188e5ad2acb6077172c924e9b85e105ead26" => :high_sierra
    sha256 "d6570e4dfd7f915341264dd1e0638b982e6bcca99dd8759f08cda6183ea8330b" => :sierra
    sha256 "6eaaee6b26871e6fd9c7a20448939a1e93c0827e8c6d2e506fb1bde597ba156c" => :el_capitan
  end

  depends_on "pkg-config" => :build
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
