class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.60.tar.gz"
  sha256 "340bdafedc0d5cdad812ca7372667df95078fd068a09e4fdff23a3fb8a560572"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056e1f1a964646ac14d49ea7463066a37c5ea71873a836c5802101f9a06e9bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e69aa68c80897631eacfd5ed83c07182b82975a4d0fde7100755a4aa10c7938"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20d42e35cc836b2204c75160076b8bfc0c0cfdc5fbb7293163ffd67e0597930a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb736a1c3863b7aa0246026ae92dacb5ec939a834ae7eaca361552db00c571ad"
    sha256 cellar: :any_skip_relocation, ventura:       "59362099789a5b6df054b487fd8596dbb67b005373e5a335142352c28a53aff1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571adc367cb5532a142d29f691cbdc2d786493830916326b7f25270cb07f2d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3908106cdce8f914f9ba1add655afa9fc909812a047c3cfa3b83d72857412b"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
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

    # pkgconf cannot find tcl-tk on Linux correctly, so we manually set the include and libs
    if OS.linux?
      tcltk_version = Formula["tcl-tk"].version.major_minor
      ENV["TCL_INCLUDE"] = "-I#{Formula["tcl-tk"].opt_include}/tcl-tk"
      ENV["TCL_LIBS"] = "-L#{Formula["tcl-tk"].opt_lib} -ltcl#{tcltk_version} -ltclstub"
      # Homebrew installed tcl-tk library has major_minor version suffix
      inreplace "configure", "'' tcl tcl8.8 tcl8.7 tcl8.6 tcl8.5", "'' tcl#{tcltk_version}"
    end

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
