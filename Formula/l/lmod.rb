class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.32.tar.gz"
  sha256 "727df3dafb634749947418b334a0828d63753c38f02d4d7a27c6c507e9512d3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a682af3bec8b19280f333227bbef04e5a3ee5c5d290d9eb2a573c867955fbc93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6609bccfeaf05b2beab6ec3db4d107c9e556e626e3bae0fa354356e9794875a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55bdaf106c74edd39b413a507a98af91026181b9903abaad8668855f7001f65b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55568faf5442ab1e8a232bb6cdce5c8ba863529a82184c28a5868908bdd0736d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3337c719e4c100021b7af7ee560e3c9cdf2757ff804e6f4669d13c1a6bb2c789"
    sha256 cellar: :any_skip_relocation, ventura:        "9123f03a3bd328a6d5625a45f5a96623fb4d2f06c624d7530230e52d9fcf45d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1924cb4220720d0ea3e0e7940928b3c7724e699c55ec8168aa5d9b26ee4dcc1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce53fa5a43c5ebfc09928c41f07e0580466abb5fe52c511859c6dd85ac5b50ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df91f1def481cdd452e62641750e2ad499310a8b66ef05100d0cede32e9b3c2"
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
