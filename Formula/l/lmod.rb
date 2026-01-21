class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/9.0.5.tar.gz"
  sha256 "7d5b5db9f252dff7469d3a5369b7b58dbbfd4b3a879a97ee21954f26e04b13e3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7517a87455dc9a52a896c35dd8036dc7aba34b7742deb6d2fc932aa3e73341af"
    sha256 cellar: :any,                 arm64_sequoia: "b69db71ff9e0cc5a11c88e689b8046e7bc42a5c6406ba128f65196ec4b734cb4"
    sha256 cellar: :any,                 arm64_sonoma:  "9415728157c8e19e1b681e5446e4d41446cb30e98adfe6fd6fd53f4644414718"
    sha256 cellar: :any,                 sonoma:        "51d4b1b2ed9b6986060ff517134b2558f73589c41469af414e68e8a3ea774d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1c0b52c6caf7d3a92f377e624863ea5401c78c802c3d1f5ed1c8e7639d7f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb551c67e48d20a359d0dc484c622016d88682022eb173410fc4c47a8a4458a"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"
  depends_on "tcl-tk"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    # configure overrides PKG_CONFIG_PATH with TCL_PKG_CONFIG_DIR value
    ENV["TCL_PKG_CONFIG_DIR"] = ENV["PKG_CONFIG_PATH"]

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"

    # Remove man page which conflicts with `modules` formula
    rm man1/"module.1"
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

    (testpath/"lmodtest.sh").write <<~SHELL
      #!/bin/sh
      . #{sh_init}
      module list
    SHELL

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
