class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.15.tar.gz"
  sha256 "91d8c637c51f4189feca8cc32f19f7ea50e0e14fc6e81eae6146e8bbd84179f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb65d413e7088b9fec43c774c226ef5f6e1559f469b08450d2adabe596d40d0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b48bcec0211718c11079e77339fb16ce503cbdf8637cd84a1a2521faff3754c"
    sha256 cellar: :any_skip_relocation, monterey:       "c33cbe90ba868ab9648d9e4fd23adc765b5f2bbdd59cfda2daec3758244c6e22"
    sha256 cellar: :any_skip_relocation, big_sur:        "96fa7ca58c46b12f813de82275dee24e29cfe26291d7c264bf9bcafc1365c05d"
    sha256 cellar: :any_skip_relocation, catalina:       "f44213463a0bc5f1ff8da8620e4face2ac7128759b0a6acbb5fd953dc027a667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b057eac88cb54d4cec03ded879a02a31902fdae1abe4de24252ab9eca957ba"
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
