class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.9.1.tar.gz"
  sha256 "ffafd83b1c42aa38042166a59ac3b618c838ce4e63f4ace9d961a5679ef58253"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{/luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "965d32fb05b950400ddfa6586c208d6b108fefafbd82aac77f423961447df7ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2fcf803a9a182998eb4e0a674edc53fb98b75725fb390aa112b33bfab40298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c2fcf803a9a182998eb4e0a674edc53fb98b75725fb390aa112b33bfab40298"
    sha256 cellar: :any_skip_relocation, ventura:        "cd97356f99bb752439b21a7c5188bc61e9f9c0cbf46e09c82e8c110f9cf54765"
    sha256 cellar: :any_skip_relocation, monterey:       "da96512ca94b72a6fb60859da82fd31f1428d5a2e016e082982a284d1873ba5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "da96512ca94b72a6fb60859da82fd31f1428d5a2e016e082982a284d1873ba5b"
    sha256 cellar: :any_skip_relocation, catalina:       "da96512ca94b72a6fb60859da82fd31f1428d5a2e016e082982a284d1873ba5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2fcf803a9a182998eb4e0a674edc53fb98b75725fb390aa112b33bfab40298"
  end

  depends_on "lua@5.1" => :test
  depends_on "lua@5.3" => :test
  depends_on "luajit" => :test
  depends_on "lua"

  uses_from_macos "unzip"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      LuaRocks supports multiple versions of Lua. By default it is configured
      to use Lua#{Formula["lua"].version.major_minor}, but you can require it to use another version at runtime
      with the `--lua-dir` flag, like this:

        luarocks --lua-dir=#{Formula["lua@5.1"].opt_prefix} install say
    EOS
  end

  test do
    luas = [
      Formula["lua"],
      Formula["lua@5.3"],
      Formula["lua@5.1"],
    ]

    luas.each do |lua|
      luaversion = lua.version.major_minor
      luaexec = "#{lua.bin}/lua-#{luaversion}"
      ENV["LUA_PATH"] = "#{testpath}/share/lua/#{luaversion}/?.lua"
      ENV["LUA_CPATH"] = "#{testpath}/lib/lua/#{luaversion}/?.so"

      system "#{bin}/luarocks", "install",
                                "luafilesystem",
                                "--tree=#{testpath}",
                                "--lua-dir=#{lua.opt_prefix}"

      system luaexec, "-e", "require('lfs')"

      case luaversion
      when "5.1"
        (testpath/"lfs_#{luaversion}test.lua").write <<~EOS
          require("lfs")
          lfs.mkdir("blank_space")
        EOS

        system luaexec, "lfs_#{luaversion}test.lua"
        assert_predicate testpath/"blank_space", :directory?,
          "Luafilesystem failed to create the expected directory"

        # LuaJIT is compatible with lua5.1, so we can also test it here
        rmdir testpath/"blank_space"
        system Formula["luajit"].bin/"luajit", "lfs_#{luaversion}test.lua"
        assert_predicate testpath/"blank_space", :directory?,
          "Luafilesystem failed to create the expected directory"
      else
        (testpath/"lfs_#{luaversion}test.lua").write <<~EOS
          require("lfs")
          print(lfs.currentdir())
        EOS

        assert_match testpath.to_s, shell_output("#{luaexec} lfs_#{luaversion}test.lua")
      end
    end
  end
end
