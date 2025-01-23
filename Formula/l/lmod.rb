class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.55.tar.gz"
  sha256 "f85ed9b55c23afb563fa99c7201037628be016e8d88a1aa8dba4632c0ab450bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4680503b309463f94e52c0e3643f23842fff01cab415d383ccc817717f5e77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b9d3a46c8f2aa9b20b91ef2c2284ffdec5e5b363a0a8a04003cfd17c00e0b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "547b23347fd3405672c92ef959482c5acca1787fd48f5df7e34ce8f920d8bbbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cb6dfd71c4475f3102dda0ab4081db2dc9e5a637d108f01d258eaf07f7daf3a"
    sha256 cellar: :any_skip_relocation, ventura:       "94f0ca9b0ff0cc71628be0e4f91e6d23ecf34da16217c0721f3d82e62148c5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c572c74143a5e8b1f477a7ebde8633ef7096004ad4add242ae1cb3f163833b"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "tcl-tk@8" # TCL 9 issue: https://github.com/TACC/Lmod/issues/728
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v36.2.1.tar.gz"
    sha256 "44e5087cd3c47058f9934b90c0017e4cf870b71619f99707dd433074622debb1"
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

    # We install `tcl-tk` headers in a subdirectory to avoid conflicts with other formulae.
    ENV.append_to_cflags "-I#{Formula["tcl-tk@8"].opt_include}/tcl-tk" if OS.linux?
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
