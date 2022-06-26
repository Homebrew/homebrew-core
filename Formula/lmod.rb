class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.6.tar.gz"
  sha256 "e6fb88974208e1416d774a449cc3f157efb1094a6e1d8f34e72cb69bb869307f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f6d9c760b0875733875b257610a6796cc05d399451ddfa36464928a1ce87d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37636aa8f2640df7763f28d6aa988912d42294786470da16022523ae996efbb2"
    sha256 cellar: :any_skip_relocation, monterey:       "100275570cacab7c5295a132aff9676862b2d4f48a1866224141df40c8f46022"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c59b812da0ed40561ae5799dd5b59cb78c94f6d71722ac0644f6347bba50279"
    sha256 cellar: :any_skip_relocation, catalina:       "3eabb4a5662f080e94ef596148ed656a46a15567bc1374d8cdfc1f6f8f0a93d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad86338e8ae4bd0c5aae7f27038a626f8b16cf791359aafaa2ab65f18eec691"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "libxcrypt"
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
