class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.9.0.tar.gz"
  sha256 "5e840f0224891de96be4139e9475d3b1de7af3a32b95c1bdf05394563c60175f"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{/luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76de7f329ce7581667043bab3d2676dcbe238167296c998881ef22621a1d157f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76de7f329ce7581667043bab3d2676dcbe238167296c998881ef22621a1d157f"
    sha256 cellar: :any_skip_relocation, monterey:       "3d91ab635009813c54df5bc47909d29399c3c771553b25294cef3c57bd3dc0d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d91ab635009813c54df5bc47909d29399c3c771553b25294cef3c57bd3dc0d3"
    sha256 cellar: :any_skip_relocation, catalina:       "3d91ab635009813c54df5bc47909d29399c3c771553b25294cef3c57bd3dc0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76de7f329ce7581667043bab3d2676dcbe238167296c998881ef22621a1d157f"
  end

  depends_on "lua@5.1" => :test
  depends_on "lua@5.3" => :test
  depends_on "luajit-openresty" => :test
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
        system "#{Formula["luajit-openresty"].bin}/luajit", "lfs_#{luaversion}test.lua"
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
