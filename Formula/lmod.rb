class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.13.tar.gz"
  sha256 "716ff21262c2eff239ccc1dddb7d0907a32d3e9d4bf6724f146bc5ec32c8fc9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae155e0e13c0242559115cbe4ce1cc760537ea20eecee7d437b74bbd9bbc3038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fd367e3b87b682858d8a2168ffd27f4ade7a13cbbc62bca7bc4b76fc21a14ca"
    sha256 cellar: :any_skip_relocation, monterey:       "feba2f434633431f480cf38692fd2434c455674e463f2adc1dcb2f84edb0570a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9641b1abe6a3f6fa04e395a0dedbb996b34f7f595d17d18c2f8cd3f9afd5a74f"
    sha256 cellar: :any_skip_relocation, catalina:       "1b75cd7ebd22029dba3c75c4ab76780b448ab4d32358a7579818fb5478358059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b8e86af119d85e6f4963ee0dfe64731ab27c56a72150e8606df57cbb27f077"
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
