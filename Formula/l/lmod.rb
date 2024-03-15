class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.36.tar.gz"
  sha256 "a6ae83d9122bd73c67d92e2b192d7d2adeea56a590b7ca7365ca8ce66f313893"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65ceca481c7ff9774d39601183ebf1f6bf817ac5d9d459e605d6131eb348f676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eb7a1d77a3a0286fd361d1a01eb61deea4fb068f14b7bfceafd586ad1919654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada19adab7892ab735c158a3abc49b1594ba52a701cfe24a1a139184cf07d898"
    sha256 cellar: :any_skip_relocation, sonoma:         "b20fb4280a0b04ff4fefb9bbb1b22014857bb5f215f73229905708055897cd2d"
    sha256 cellar: :any_skip_relocation, ventura:        "0661ad901d69ad20373cc7f8b2e385d87ac138a2a9533afc36ff88e1c571a268"
    sha256 cellar: :any_skip_relocation, monterey:       "e47a56a61768a8cbd8c41dd77460818f1b46ce232b522f008c4105b81cae8b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb832660d1bf0a8ff159a9ab7c5194b7f23b8780e3bcb62c89f9a06eb333febc"
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
