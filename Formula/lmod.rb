class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.2.tar.gz"
  sha256 "5f44f3783496d2d597ced7531e1714c740dbb2883a7d16fde362135fb0b0fd96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "968dbc23d90684f52a671e2593413171f703786f0443228c8648e2cc368c3ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0ffac8970c3fac689fe10068887b0b6be5524de6bbdf475315aee538f6546e5"
    sha256 cellar: :any_skip_relocation, monterey:       "fc683bbf7c779c07553730ffadf8dc0c2f5b7f8ab427e94c3698391c0bca9bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "f908f794735f08aba94f25687ee5de706520efe15f7e4449a1ebaf7c78da8074"
    sha256 cellar: :any_skip_relocation, catalina:       "1500b11bca29d37447fbb43a5c016973f0c45f248133cf3a1879d8ec9a0e0ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "138bd4fe5f18ee2bf89657a54d6f5bfbc0d3cd3e4b49abf219056bd50761f0ee"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "tcl-tk"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v35.1.tar.gz"
    sha256 "1b5c48d2abd59de0738d1fc1e6204e44979ad2a1a26e8e22a2d6215dd502c797"
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
