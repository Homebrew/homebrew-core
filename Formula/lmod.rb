class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.20.tar.gz"
  sha256 "c04deff7d2ca354610a362459a7aa9a1c642a095e45a4b0bb2471bb3254e85f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "410268fad296d99c45ea7e5081b431a4c88efdb9e52b7ec23ab07939eeae1c10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52fa0ecabad60ec55cc566fbb3aefacdb443398a400ee17ce966f8c5de2f790f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c759b506b83f1cdaae843c14880ed80e9a4e77c571df9a871a20dcacfab390e7"
    sha256 cellar: :any_skip_relocation, ventura:        "37cb1caae54821ee7853af2d1d5a6bcbda5296d4845c1c58406aa7a6cef1245f"
    sha256 cellar: :any_skip_relocation, monterey:       "c5aec214501e4e8bc9d693e6c533554cc89f4f97cced2918eecf1afbd0ad2f7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d21be4c6d6b1e63a5c3049cc6461d75d493fef698a864bcbcf41dbb7e0c37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89da1221be67367c50761a38bed26c8d32b8ebe90badf879732bf2c7ab63d84"
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
