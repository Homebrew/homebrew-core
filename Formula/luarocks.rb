class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.5.0.tar.gz"
  sha256 "701d0cc0c7e97cc2cf2c2f4068fce45e52a8854f5dc6c9e49e2014202eec9a4f"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c3ade94bf5e9e76691bfae341a729a8c4031d3405194401ef7d7ecefcab3057e" => :big_sur
    sha256 "78a5601e8bc9ea85ef0819b00ed1153e28184475f3a199e5fcaca006dfe8e8c4" => :arm64_big_sur
    sha256 "70d1bab344f3868a6c728b32ccba961229c873d3c817add66e1199e76eb19fa1" => :catalina
    sha256 "c54dfe9498451a46fd617179b97229352a3bd13d812e848909a58e35419cf04f" => :mojave
  end

  depends_on "lua@5.1" => :test
  depends_on "lua@5.3" => :test
  depends_on "luajit" => :test unless Hardware::CPU.arm?
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
        unless Hardware::CPU.arm?
          rmdir testpath/"blank_space"
          system "#{Formula["luajit"].bin}/luajit", "lfs_#{luaversion}test.lua"
          assert_predicate testpath/"blank_space", :directory?,
            "Luafilesystem failed to create the expected directory"
        end
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
