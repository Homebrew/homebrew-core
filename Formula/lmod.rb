class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.17.tar.gz"
  sha256 "11f231dba5cae3be896eb4988172fcd75bd60acb5f0844d3b81a571460fed766"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b97ed489ae1f50796ce253c58fa69b666e50e88530168f2d50776451e181d020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "643b3710c17869a74174e5fa115e83fe8a6d7f039e91df89eecde6a83fa4b0b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fd3b1be5afd57a78990e6d5faf8d3fe07688cb1904971b64a604e8d89043e83"
    sha256 cellar: :any_skip_relocation, ventura:        "98f7b797578bde16c5e9f6be20fd123e7eddafd5e6ea4f7e5e3006eeb60b6eb6"
    sha256 cellar: :any_skip_relocation, monterey:       "16d98dd7575296c8b62c731243bc6f8de23ce45eb22f3858000b62e9b2694389"
    sha256 cellar: :any_skip_relocation, big_sur:        "802f1582bafd3f5e0a6b239c9deb7d5f400d656e531d8cc2d2f57cd13ce8dd50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ae73dd9e89f89e36fda1a9c424e01840ba6d926c0a63038cd4d15862becf62"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
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
