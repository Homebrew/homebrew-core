class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.21.tar.gz"
  sha256 "2b856e8becbf24bf060da635349042db9ef278cded01178697907143cb5e3b99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b39a8bff74b6f9741c73c0f09387e0246ebcb3668420027481d3d545c638b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5458a1dc22a4de428e81af6e340d7260c4df68651c767bd59562b9ea53b705d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7dcf78052c4abd9376e879aa40a189a00dae92f2dd1248de009d4f26b53d766"
    sha256 cellar: :any_skip_relocation, ventura:        "eb6af63a43ba70b08fc8eec1a94cbfe97ed1c728063e8d679ef4416217320393"
    sha256 cellar: :any_skip_relocation, monterey:       "b983a6e6871ab154524fa86e180d7924c07af8cd38f33e061a9288b47db7879d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cae6a692834bcf16c2e2d2db585f89da6d99a4524b10d82983fa9de7e7ba90b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df4bb1cf1c24ff014c5dcf1c8788a715372ce7c18b1836084664a5a73df9313c"
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
