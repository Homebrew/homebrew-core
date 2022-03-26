class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.17.tar.gz"
  sha256 "2d98e7e0c9bd3c7b6946811f7cfbcfcc339d275dfd18acac47d82a0daefda8a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f4a85d16eff2e75df1ec955438b9ab3e1f1267716178f0495e7a49f58f3dd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ebcd473d921c43eb7793262b534338dc05f32a93a405fe758542220ba794635"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f28a76160f5a6141ab783d88ec1daf43c9f13d1ffc5acc1d9791e762025981"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea3744e1ba1afb52662ad378fed35a5e06f18263a799bfb6c92a6dbc9764c263"
    sha256 cellar: :any_skip_relocation, catalina:       "9db211b999fa30f438e52d133ffc12fffbcd8ea9c4b6216d28cb1094d77d4f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b432a9c2f25744ab46eb4b3da744daa4a109f3c79f6bb41a68e021c0a4bbcc"
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
