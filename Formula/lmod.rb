class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.8.tar.gz"
  sha256 "1bca1f44169d25a1c6b35a3ff6e2f74fc60636809ba8523ad44444f9c4642dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0cff5480885dfff6a13404a5f9fc869ef6ef8241d457c11dce590cc6fb22d7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7443bd6cfdc41c2af6493d8cd1a771fec04f4ca6b37761f45f08e0b006d3c76"
    sha256 cellar: :any_skip_relocation, monterey:       "617a2666b2ede6c985d97ba637f5cef3ebd40193f63d0d2cad21fce8ab245749"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccc646b65b971377dedc811b63a323b4fc8733da7bbb2a1998c5162bce3467bc"
    sha256 cellar: :any_skip_relocation, catalina:       "f5df6884d4cf3f6951c6b330db6768ed2f6a4e8c066f0042eea1c6e29deddbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4941c384064680436b0fe6e2631e08cfdea9ca1d4218499d559428d9d0087e4"
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
