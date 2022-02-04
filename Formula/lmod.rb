class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.11.tar.gz"
  sha256 "2077aa0af1959a0c7b925eba2be1fa3277e75aaf4da7da34d93583ae78445b1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab2daa7fd8fadf2417cdd4c44b4661a687f80e64f17e39b943ecf95dd8799ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34b6dd992752a141307ef4286931e0d802c8a0ee25baac47245cabddc04054d"
    sha256 cellar: :any_skip_relocation, monterey:       "6ed3745561f3357361c0b43b11990be5bdec6de3bcab49ff1dbf9d26f9b7c6b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cf5905a99614e2ee60065b11db9137c9ba811b1cba895cac84ef411d2aeafaf"
    sha256 cellar: :any_skip_relocation, catalina:       "e3b8279c961e12375f69b636ac236ed2e51cc1149488290e1fe388b06b9538eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6c0396fdbbeaff9004a01264169088b2c97de4c5c8f20391a2e23805797807"
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
