class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.36.tar.gz"
  sha256 "a6ae83d9122bd73c67d92e2b192d7d2adeea56a590b7ca7365ca8ce66f313893"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "109edd45c09a706d8839bb43b05ba78b32042b7a7abf941ec5960ca008dbe04f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ecf03dd830ba194cb31623802b588e9b41d81c7cc3c94d5f7790f8483339350"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e003cadd4045f9af20992673b7c647c1b4a2454257d16f2ffd52f8c5d64bf2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf75fa191b5f2298df9944276a2fb6b1fc05fa2462e02fcf524f1868ee718fa7"
    sha256 cellar: :any_skip_relocation, ventura:        "d3cd8f6e2164de0795364ecf00635549d453b8587575bbd27757c6195ff2270c"
    sha256 cellar: :any_skip_relocation, monterey:       "67481cc7dacce566bb450f6f200087308bf6b276b5f9cd317023632904ec7433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adfba1e227f19afed20f519feec0bd7f716d638e8aa043a6a632c89dbe88ce9"
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
