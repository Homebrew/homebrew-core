class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.23.tar.gz"
  sha256 "9dacde7c32afcf60d81431003d79f3eee299f6a4fef4af7c240fff89dc2f61d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2ebedf4328de9410f6efc7f096c23748cc9e48e44dfe5cb5ca51c40e230ef43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa0ff604aa7548049f90299b475f3e54ca6b07659197a986667fe54f219e6a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41c31af4dc38f9861a2c5f236aed34c5919d477b702c078435ddcda945fb2249"
    sha256 cellar: :any_skip_relocation, ventura:        "76dc5edef0b4d81ae13957ed98784dd5be95c4ec980235e2101a375a94cb0347"
    sha256 cellar: :any_skip_relocation, monterey:       "a097f5761482c48608fc7aaf3c4dd82338dd70502e0ea41b0e476e14f1f922c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "42a6753ca5695ea9409bf8e0c31dda85f74747f62b022901f82dc7bb07f53dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56cdfbc5e2566aaa0e9d12133502c968f209d3741d8dc1c3e33b41963796af2a"
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
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v36.1.tar.gz"
    sha256 "e680ba9b9c7ae28c0598942cb00df7c7fbc70b82863bb55f028ea7dc101e39ac"
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

    # We install `tcl-tk` headers in a subdirectory to avoid conflicts with other formulae.
    ENV.append_to_cflags "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" if OS.linux?
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
