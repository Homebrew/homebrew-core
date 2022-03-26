class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.17.tar.gz"
  sha256 "2d98e7e0c9bd3c7b6946811f7cfbcfcc339d275dfd18acac47d82a0daefda8a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d748f1da26a40b8968bf5cddb085ecf275e1798f8e8327769d89d565dd5153"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25dcf4bdd1b1012e3292c4b333eb8d8b0f01622510168abde22769042f54efa"
    sha256 cellar: :any_skip_relocation, monterey:       "0034c1378af17a60907fecd64d05746aa89b32a5d795a6358def8a2d53413af0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e732bc442fedef9cb31dac2c2ec2add3c8594267032f311528017f79c37da064"
    sha256 cellar: :any_skip_relocation, catalina:       "55fb8a5dd5d671bd69ac2346866a20b8e0b34edc9644a3ca7f450676180b2210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99448217a2664673719e733d915258dce309c85be9cfd3841d3e225cd8655ad"
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
