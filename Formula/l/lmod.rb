class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.31.tar.gz"
  sha256 "2e7745901e0a918e2043ac8b1276b3bf59ff0793dc45db16788f18e0019aca39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f07efb4f0bd2047152ddd4478964532153ec5f6d869d056e1956aea274e88537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62ec167344e15dbc6ddeaa8cef7f2da0b9a55006f5e2e532db29a2dc4e067e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e2f5aae548d29b23940aa5a3b2dd435f1f3d4bb3314fa0514a4b7b5d7288049"
    sha256 cellar: :any_skip_relocation, ventura:        "a3fe13cae7e84acddaa2f188386bb0a59dc01c70693dd7983a92e104f70b5e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d76b444dfec1623f991253efa79cfc883082eb296fa0a1af443d1c31fe8ec0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdd7111ac7ba76ca6f355f3a3c5f4e9f1387ee3d8a6c896e81cbe36febfa2bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729c91b08cfff610b0d04d60f7688b2e45ee0c42f166373ca281df84ac796857"
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
