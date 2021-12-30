class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.3.tar.gz"
  sha256 "7e259c4e92a5d6d75872d32161985f6f3b389b8f545d8851ac86e9d5eae859e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a24091c1ce9e064f42947a03c2aa146f78254259c87d391e39cbf281b663f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8e82697141a5dcc232fa8d716610eb3340c450bc13e627c4274f0f21b0a0418"
    sha256 cellar: :any_skip_relocation, monterey:       "f6065baa2cd4d40cb9a5dc126522bcfa45e531cf909144cf24a8cc21ea728552"
    sha256 cellar: :any_skip_relocation, big_sur:        "63fa2875c0572205742f0a7f77309dea5122f541cd80450d1001f7718015e394"
    sha256 cellar: :any_skip_relocation, catalina:       "2d606bdc445659319fcde4bd2b1a116483fe557196077a43351ff5f4fad60e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f59f957585ae0703aefb6317e5aff2fc94bd668e9cf9ac9d17a2a9b4294726f"
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
