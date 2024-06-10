class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.39.tar.gz"
  sha256 "cdc2da3808ee66a727d84ff7a64668af1c1959dc81dfac19be4e90789a8094fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "922c4d1649e41f3e9b30fb5842e3715c853f52e9682ee0a185ca67f7a8097461"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd794ff0ecbfe36642002e8e9230a120a11911aa5e19457c541881ef42337ccf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1df198c8e1adaeba07659f97ee4b3b98a0794f3d9161ffa8f022e3233b0ab05"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd018aa4a1f5d37fbdac2e630eaafa3bc16238cb7dc1373106e6a4d227c474e0"
    sha256 cellar: :any_skip_relocation, ventura:        "f2101ca7c8bc5ca717765d3d975877a30e18f13664ba85ef962e857b07ea7931"
    sha256 cellar: :any_skip_relocation, monterey:       "ce4337538aedb8f4a13ca9300cc664c509680306451537f8032963dd9d23e28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa7aa46f9d137131b38ce50817bd9f7a7ee4470eaf98b0f6d45624fc3adfdf14"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gnu-sed" => :build
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
