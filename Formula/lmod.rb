class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.6.tar.gz"
  sha256 "e6fb88974208e1416d774a449cc3f157efb1094a6e1d8f34e72cb69bb869307f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d833177be00843a907ddb877b38dfc0296736788e7a2224c6080c716aeb22955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c9321abbdd2fd3488016df4d44d58336deba26364eec71ea1b087737258623d"
    sha256 cellar: :any_skip_relocation, monterey:       "ec69eab05a27f5f69f29dcb3ec026fa208dc00c8515c6d3c86d81021354bf1ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ab9d33a53ab6c000ca00b7a1f4b703aa67f076a3a552b25a56ae5aac0e26165"
    sha256 cellar: :any_skip_relocation, catalina:       "ebc238df08ef33f5a7cf70776b9be79ab38adf1287316400255f31a632bd3d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7e944a02622baff5c4d969040963161dff58c4d7d3d7bddde6f07e6392b93c"
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
