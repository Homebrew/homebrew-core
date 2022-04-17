class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.tar.gz"
  sha256 "f8bf4cea79e743a8ffcde3525520fa28595fe15fc3e8582deec22583e9166d93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849f2fa668707f0895a257a89fa5133744a8313164fc3e934c8a2e512b317656"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "853e4c60a92fc6fbb3e19323b7164ddccc9900f2e8854324163c6498bf1826f9"
    sha256 cellar: :any_skip_relocation, monterey:       "972b2b4b8df95aafb00a807d83292df7db5bce5d952fe594a0f56be180a1ef91"
    sha256 cellar: :any_skip_relocation, big_sur:        "f014ee21cc95d83a78b21c68d811ac55370af3594e0939c522a97a65dfd3c93a"
    sha256 cellar: :any_skip_relocation, catalina:       "6468f82f8a98759861963a7a8891d07bcdf29540f22daafc5720c17e1f8b5d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9608d41f45e438500d8805fbe82e25cdeadd27eaee5a1fbc929c30d30f6d1e7d"
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
