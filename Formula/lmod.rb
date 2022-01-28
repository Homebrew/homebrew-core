class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.8.tar.gz"
  sha256 "1bca1f44169d25a1c6b35a3ff6e2f74fc60636809ba8523ad44444f9c4642dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63e96cd415f8ab921d4013caf71dd26cfb23d758d43aa7cd7ef983d44e2007e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf3f3da8bb46175cdf7e75ee7935bb9066020fd8527c60bcd28758399f96e776"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e84d8a912ff863bcae0f779aabb42cc9025146f903121d78d9197de1ca3956"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb98a6941b870a989558b2f7f7ec6b7194d1bd3a206069c0dc091dc6deb2d6f9"
    sha256 cellar: :any_skip_relocation, catalina:       "cbe4dd233f75262691129d17537e5868051ecbfd63d2d62d7b0b9b236fea56f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75412102cd7ca667de985b7d7c1257be66ef688e47be444e8e5ae19591952b06"
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
