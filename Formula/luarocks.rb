class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.7.0.tar.gz"
  sha256 "9255d97fee95cec5b54fc6ac718b11bf5029e45bed7873e053314919cd448551"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dc31789a37d4d1af62912076a88d985a6b3e223cfbf0301edf80583454c68a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc1a0cf24af052f5f0c05c2a3a3ce928b193f6fb7c67c82ef458a25338f07254"
    sha256 cellar: :any_skip_relocation, catalina:      "0e976588a495ed84e45d0b76b8622148d6b401ab94e262b604d8759d1cdcec2d"
    sha256 cellar: :any_skip_relocation, mojave:        "8fd471acf58802ac4237674d499d295720171008eaa4bdcbaa3cf02633ddeacf"
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
