class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.1.3.tar.gz"
  sha256 "c573435f495aac159e34eaa0a3847172a2298eb6295fcdc35d565f9f9b990513"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1acb2e90bea4f3056dd34e95335bbd916034a47ec53813d7b4d0cba9c34fb08" => :mojave
    sha256 "7a23c8cd3129369ae7502801765242e2e8a1f4afaf6c58d09b812654d5ba2dd3" => :high_sierra
    sha256 "7a23c8cd3129369ae7502801765242e2e8a1f4afaf6c58d09b812654d5ba2dd3" => :sierra
    sha256 "7a23c8cd3129369ae7502801765242e2e8a1f4afaf6c58d09b812654d5ba2dd3" => :el_capitan
  end

  depends_on "lua@5.1" => :test
  depends_on "lua"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  def caveats; <<~EOS
    LuaRocks supports multiple versions of Lua. By default it is configured
    to use Lua5.3, but you can require it to use another version at runtime
    with the `--lua-dir` flag, like this:

      luarocks --lua-dir=#{Formula["lua@5.1"].opt_prefix} install say
  EOS
  end

  test do
    ENV["LUA_PATH"] = "#{testpath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{testpath}/lib/lua/5.3/?.so"

    (testpath/"lfs_53test.lua").write <<~EOS
      require("lfs")
      print(lfs.currentdir())
    EOS

    system "#{bin}/luarocks", "--tree=#{testpath}", "install", "luafilesystem"
    system "lua", "-e", "require('lfs')"
    assert_match testpath.to_s, shell_output("lua lfs_53test.lua")

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
