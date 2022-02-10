class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.12.tar.gz"
  sha256 "d17989486d39b5a89f3862ca3bac5104b1afd7531279b9ffba98a4e6c7fe3ed5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d7b540e53b9842b4b26ff55c1e75b5ccf5641e04f5e44e467de361c847280ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e005ea30bae0fdcc1dc3a0bd1f3a3f4cd5351869e75b13119a259cad2eb661"
    sha256 cellar: :any_skip_relocation, monterey:       "df07ec0228d8f291da48da53c824a1fa719b71fb5941c4f92df01acc80e18b2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "477119325616d4809d93f171ce7b618419e7b814467d9654b999143d4229cd92"
    sha256 cellar: :any_skip_relocation, catalina:       "e23969c9a149d6d8f84a3c2496adba330433d9b95cc2211d79bc6b4ae762061d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a512b3f1c539893d736058647c8dfcf405cca958c639e514452098df4a17671"
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
