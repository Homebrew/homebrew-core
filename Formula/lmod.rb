class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.25.tar.gz"
  sha256 "8f5096bdf80644fb3dec1f2209386a62b4e5b6cdc2051e15d8c22110eb56fff7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b510ec691edd461c404c05cad7222f5c934ec65d33d1dc01937e80081e04bf3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e59740135f3c7d8377d7bbaff83ad788a5cbdf64eb80742735231219aef4dc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37563a8fae54fbedb56e5a53d4befe9d74196aa7688f1aeb3656253adfbbd450"
    sha256 cellar: :any_skip_relocation, ventura:        "b97b9004a9040066af5859feddbe5e5636046ab1395a8fdd890006ce8b93306a"
    sha256 cellar: :any_skip_relocation, monterey:       "98f1c2e930b0d77e294749cd5b76c09f73de66492fbd0e1b94e47dab6aa557f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e38bf13e33a75756364d9d85d1dcc9847b1786eeb0e50d6593ede1ce38aa03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47288a97c125a0a649bae20017c0e24717c8930a4d66a2c2c965790c7e78123a"
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
