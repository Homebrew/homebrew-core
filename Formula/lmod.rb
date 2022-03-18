class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.15.tar.gz"
  sha256 "91d8c637c51f4189feca8cc32f19f7ea50e0e14fc6e81eae6146e8bbd84179f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14066db5eba61b32565cda1b9319785d0dfa30a8964b4636e44ec3c2906b2c57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9055b33844364ac37440a05c93e135b17e599d184280be21a40f8dba4dfe866c"
    sha256 cellar: :any_skip_relocation, monterey:       "80239ad1f33a80a601a4879b7d8e016eb78d8c457440047ce10baae8f78cb367"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b326a139af6ad584694a44cad31649f6f42024745f771afba5759ff49883c71"
    sha256 cellar: :any_skip_relocation, catalina:       "0e7906d9e25d0cc374423e0390e90a5e784c2408a8ed38d4ff3b5c88fbaf9089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de257abc8191c3437af8934e307a81ecd7896b5a7bfbb8cd1b6060d1bd8f79cb"
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
