class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.27.tar.gz"
  sha256 "8ad238f363be6a8c0947ccace6d1c58e35cb1c3f51f7e39c3d4ec2b644b22ec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "891e537435c073e7f127f7b3ac7ef8b22f8586614a847b9ad18195ab06ab2244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2e8db28a2afcbeb51b23c1a162eb57c0ba64a78e9b47c098c365434a2b60124"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68631f12c9c454b3f125451750d0e7425532a3a69112d4176867c3bf84844958"
    sha256 cellar: :any_skip_relocation, ventura:        "652478703a8e6733ee76b75384038b41da07b6e98d85753cffb37a57396b14f3"
    sha256 cellar: :any_skip_relocation, monterey:       "1ab5eb10c7b9dc65b60ad48a1614d62b4d09a5ac4c404e2a434cbf0149b0e612"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ffeeeadf551b552669417bcbb2dca42dca8ea94a5179f146909e5cd2f575816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c3fab607aadb8f94eae9c2b8e26b449616bf0155e904026f77fb5cbfae43ea"
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
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v36.1.tar.gz"
    sha256 "e680ba9b9c7ae28c0598942cb00df7c7fbc70b82863bb55f028ea7dc101e39ac"
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
