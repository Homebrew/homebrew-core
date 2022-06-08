class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.4.tar.gz"
  sha256 "acc71d2c6cd1135b04ff03ebceff3e88c03b999afccfb887f26c1d84bce9a6b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d69a4e3279d4bab06637fa3ac0ee14fe6bccea61e91acf079c26d106d6a55b43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af37060286aec93c5b383fbea7103b8840c45072ea6865a4dbf03e341fa285b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e7fbf309b137ebfff08dce0998f21c0fb38d9bf55c176fd324c3a69060e80d6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d87a7c45f170178f32e3e312e15bec6e5daab87295d84d210805e8dd8061a091"
    sha256 cellar: :any_skip_relocation, catalina:       "b7c8851625a7fccf203e24325bbee378625706c107e2d763f0723a0e34dc82fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99249d0367e4535d0b6ef87fc67aa954de8f7ca56f0549224df7ae6b6b88be43"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

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
