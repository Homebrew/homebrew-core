class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.6.4.tar.gz"
  sha256 "222e08e429dbac77b0e1a6a752f6ace29863495185459c827c3fd5fc699e14cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6471efb1d0d89051010fd1027550d09bf20bb4f88514bda6a6aa08c20d7ec24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db14a10918d6b64896c00ee880e615f2492d0727ce0f1489ced46caf1176c672"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea0834cdb4066bb03030132018f3f66899707afdd5e5b3857bd492da0dc4bb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b92f4bd42db3ed22c96273f635298e5bab05a6b7ebecf85205e7f4d32efea89"
    sha256 cellar: :any_skip_relocation, catalina:       "250b027127e84ad6120982488b7cbdee7a717cbbef10967447ae091cdd996ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "414b83fbc807e96de616a8031aff4b5a1399b9a370d7e61da19b8d2d319eee45"
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
