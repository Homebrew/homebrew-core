class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.9.tar.gz"
  sha256 "c4d06c697245457601535f7b1e605a2f75c4a0d1997e4455648d08c96a44ada8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c362714c5c172d9f6e83711996ff990e5ff9d03355bba63ab65ccdc0706e4c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeb054e428bb305fadf05b2d5e7b7d6adae269116cc1cf8194fa4d821b6858d7"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d27d96138600670a7359fc99fa614857020cd0556f4815449dd32f5d68a06e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e73ce5653e89b1843c909ffdda95656c51c778feb9d93d39ca30f46d14a72953"
    sha256 cellar: :any_skip_relocation, catalina:       "9edd87a273ae84098a12f22f1012cb7f4a84675804cba6e96d536e88ddd6a59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75b7574425b38d4c1b4d7705194e49f4e7ebd69c0afc19f51473d364e94ea6ba"
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
