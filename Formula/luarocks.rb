class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.9.2.tar.gz"
  sha256 "bca6e4ecc02c203e070acdb5f586045d45c078896f6236eb46aa33ccd9b94edb"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{/luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c82ed75f35abd93f042561f4ed3b1e350a4ead7596bea57b8100adc73fb066d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c82ed75f35abd93f042561f4ed3b1e350a4ead7596bea57b8100adc73fb066d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c82ed75f35abd93f042561f4ed3b1e350a4ead7596bea57b8100adc73fb066d"
    sha256 cellar: :any_skip_relocation, ventura:        "77d0eb8f6d9d3a509f48f11c34f84d13de71d106ab71ac13466b1f5cf3b61d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "77d0eb8f6d9d3a509f48f11c34f84d13de71d106ab71ac13466b1f5cf3b61d9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "77d0eb8f6d9d3a509f48f11c34f84d13de71d106ab71ac13466b1f5cf3b61d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c82ed75f35abd93f042561f4ed3b1e350a4ead7596bea57b8100adc73fb066d"
  end

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

        luarocks --lua-dir=#{Formula["lua@5.3"].opt_prefix} install say
    EOS
  end

  test do
    luas = [
      Formula["lua"],
      Formula["lua@5.3"],
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
