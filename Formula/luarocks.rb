class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.4.0.tar.gz"
  sha256 "62ce5826f0eeeb760d884ea8330cd1552b5d432138b8bade0fa72f35badd02d0"
  license "MIT"
  revision 1
  head "https://github.com/luarocks/luarocks.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a9dc3171f9b2dba8a658337e09cb6a8dce848e24c44c6f740d891c138c46799" => :big_sur
    sha256 "5e9fada325530d8177cc8d342539911ddcc494f215dee34a2aed8d9936e54561" => :catalina
    sha256 "26e55dbc66636fdc8cebd4ffd0a08a9f27930cbb9961d51d6817e0b405dd2ef3" => :mojave
    sha256 "d9ba9f1b497a18d0078ecdfe4e2e5496dd7dcdf4bb27cf78f9d80e8f4e38d6ad" => :high_sierra
  end

  depends_on "lua@5.1" => :test
  depends_on "lua"

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
    ENV["LUA_PATH"] = "#{testpath}/share/lua/5.4/?.lua"
    ENV["LUA_CPATH"] = "#{testpath}/lib/lua/5.4/?.so"

    (testpath/"lfs_54test.lua").write <<~EOS
      require("lfs")
      print(lfs.currentdir())
    EOS

    system "#{bin}/luarocks", "--tree=#{testpath}", "install", "luafilesystem"
    system "lua", "-e", "require('lfs')"
    assert_match testpath.to_s, shell_output("lua lfs_54test.lua")

    ENV["LUA_PATH"] = "#{testpath}/share/lua/5.1/?.lua"
    ENV["LUA_CPATH"] = "#{testpath}/lib/lua/5.1/?.so"

    (testpath/"lfs_51test.lua").write <<~EOS
      require("lfs")
      lfs.mkdir("blank_space")
    EOS

    system "#{bin}/luarocks", "--tree=#{testpath}",
                              "--lua-dir=#{Formula["lua@5.1"].opt_prefix}",
                              "install", "luafilesystem"
    system "lua5.1", "-e", "require('lfs')"
    system "lua5.1", "lfs_51test.lua"
    assert_predicate testpath/"blank_space", :directory?,
      "Luafilesystem failed to create the expected directory"
  end
end
