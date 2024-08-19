class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.47.tar.gz"
  sha256 "e1613094f3b2e113122ebd8edb079522a4fcbb7769044ad6cb18ce1f4f4c32d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bd57283d27cb7de72b57fcfbb54a50a5ba2f4f4266822e348a426edd0a21e37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ed7aed586317afd371590297c0caadcab056febcdb97e58e2f04aeb9bdff84f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a1d6e7f9fa311201d76844b9e97d91814d89500549abef9d8012cc6065c8db9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c34d2d428b81f6d95f0e64e9eddc29e81ba53d49319c88ad599b7e1c9baae1c2"
    sha256 cellar: :any_skip_relocation, ventura:        "938a4fec27cd8a67658b3e1f702729ccd483481b95404a5a8c11b93da5520b71"
    sha256 cellar: :any_skip_relocation, monterey:       "764987632a175b0d052ccd7bcca3abad7487b5c38f947ad179e0cd793c39ece1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7864e8a9ef42a800af587beb3f60830d8e950d6266c8f4aa085b23e3ff402940"
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
