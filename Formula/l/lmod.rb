class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/refs/tags/8.7.37.tar.gz"
  sha256 "171529152fedfbb3c45d27937b0eaa1ee62b5e5cdac3086f44a6d56e5d1d7da4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "065963be5dfaf95d811d9314e7bb9be9c1d921656ab3c3fbfdc7baa693cf5c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b7161990e71be023eddf36be396ace02f188acff9b8f6b311bb4cb613107cb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd304133dbad006c484b3644b8bcaefc946c8b389d5928590e207e6168eeb5f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e550ea041da4b6568bc79694ea498324c6fc8734a90f135d355a1a766dccb20"
    sha256 cellar: :any_skip_relocation, ventura:        "342e92c1a826ae8b2664daf34c646a5b061f98dd47b34a4dae367b8c35b6e4e5"
    sha256 cellar: :any_skip_relocation, monterey:       "fc05611a0c8aeb1ded04e185ad2c3e697877b88754c041eab4be8d2ba380518d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "448384dae9de04d4cba03800069e83e001d8573f1aa3b5f58e85e2b79778c149"
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
