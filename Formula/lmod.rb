class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.5.tar.gz"
  sha256 "4a1823264187340be11104d82f8226905daa8149186fa8615dfc742b6d19c2ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4ca831aa354bc45548f4ac207bb80cfdc6be8143e2c7aabacf1de94a7627ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "400a15f9ed66f00b3d9e0c2f94b698c6e7613ffa3f2da6ff6eb8233e6948d80f"
    sha256 cellar: :any_skip_relocation, monterey:       "bc1f2896e0a1d778937b52e3cb70ef00e09469f872ff2b6ba384a698ac1ab410"
    sha256 cellar: :any_skip_relocation, big_sur:        "358e7c5039f51b6a07cad95418088ea096314ffc6ac459a9671db32e38251cd5"
    sha256 cellar: :any_skip_relocation, catalina:       "b976bc248d45b84d74fef695ffda452d7a55240216a1118812b7a360658bd8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b94abe9cc8e0ac1486ff0e9ff0c1984336e7871cd504b7c3aae4b8c36172bf"
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
