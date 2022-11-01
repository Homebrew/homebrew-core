class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.14.tar.gz"
  sha256 "f1ee222c345f9842a0295ef4728d774b08c6f505ed12cc4a34182b779f571512"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47cca74d973d0c4e0be0a7de48168c632645a9b00f7a6697df7642ee41df876e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea4d30f3c0461f71382cb0edde7d8c0e3acac2ee329c67aee723c8ad7aa8c7de"
    sha256 cellar: :any_skip_relocation, monterey:       "d407951ad42a23364577ffbc5ddc73a5d3d9e1615283abe212d3da47ae0d5f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "608a5258c4f77092ecf4a612a46d8bcc514d6403ceb2d9b7800876999d37e929"
    sha256 cellar: :any_skip_relocation, catalina:       "b33aa380ae9825829b1d8affdd42b4f46f9b855ede58894b1a50caa7235c75f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb9ff3f287f0b1dc5ffc662b200cf31cafc3ce94ceefa33d27477bf461a1de2"
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
