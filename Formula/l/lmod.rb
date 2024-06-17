class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.40.tar.gz"
  sha256 "f8aff7716c92f48b8b722e54caa0ffaccb0304037e06a749614448584fba318d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db29e94744b17651091ebf9757d97be19d152b4faa0a5aab4c8ed65d3b0b975d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e48730b0933889589ad245d1e52b72b8e0cc40a8c0b32ef076ff9d85b1a27846"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8cae022df048e85189fab2357315e0de02173420e32a83fcb5f17d5bce18886"
    sha256 cellar: :any_skip_relocation, sonoma:         "73f853dc2eef102a530dcf45673791f7ebf3d64bab1a6cce2f0fece291fd3a0c"
    sha256 cellar: :any_skip_relocation, ventura:        "0aa93945548c819a64d69030d200168406636b08d1fac61d6d071d11f177c4de"
    sha256 cellar: :any_skip_relocation, monterey:       "5254f737174f8e69aafb83aa88225b0b499f28b6d30f10e8c441bac549eac3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "014bf9239c710ff07e53cd7f6a74669946fec56a2b8d955463dd80f304459337"
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
