class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.18.tar.gz"
  sha256 "b9912caca1557dd0c17113bceb1a4952e0ae75331d38df6361601db3f80366af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "398f8d9942acfa7e34b4f9ae1fc90a36cb536612d52c0eb090114e6fa94e77cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6e6608906daea2104c73020a3b8b85808d1cf3dff1225c76d4d807407dad09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae2ba7c435bf103216ab8d01530d5f05ded9508d4e72cf9fcc665c770bc2d3d4"
    sha256 cellar: :any_skip_relocation, ventura:        "4c711b309b778873c4549915665ad800665682e60f3ae502ab506d80cf46474a"
    sha256 cellar: :any_skip_relocation, monterey:       "17a7c220473d3fdb91a4295d962ff29c376358371c6a41da752642756457cb8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3919e03cfdd2665c692d5f383a684c64a2d11afd7979af3b9b50febd1e9c727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ce2c79e03a2c98fc1aab270d3c1664415463b602734a9048a20dbfd53c8d98"
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
