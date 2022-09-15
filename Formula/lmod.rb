class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.13.tar.gz"
  sha256 "716ff21262c2eff239ccc1dddb7d0907a32d3e9d4bf6724f146bc5ec32c8fc9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "669ad193564cc084077c3d73762bf0c1d1ede6ef4053263bdbd2bf07b3d1b13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff7d21560b2238aa6317ddabc4b15c65b58e1c5415d9381d1ed82db0b918715d"
    sha256 cellar: :any_skip_relocation, monterey:       "9cc12a3db8b5341941d01aa13cde9f5c40488d9aec5cb355fe6917d3483ebeec"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bb0024d5d5a5aaf602ca77e9cdb208012e42ddedf5d1ac5723fc021b1adedd5"
    sha256 cellar: :any_skip_relocation, catalina:       "1ad68181b72fa2290354a849045132a6b856a5e06edb9e9c1a800b64e4d67504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "097b1fd4219109498c859bb2c39a458fc4a83ce99571f47dba6a2c7794784661"
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
