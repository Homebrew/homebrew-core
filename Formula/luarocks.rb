class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.8.0.tar.gz"
  sha256 "56ab9b90f5acbc42eb7a94cf482e6c058a63e8a1effdf572b8b2a6323a06d923"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c1d3b809e453e3754e920e6b915ebe9ad2562e7de23bcea9dff62e253681882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c1d3b809e453e3754e920e6b915ebe9ad2562e7de23bcea9dff62e253681882"
    sha256 cellar: :any_skip_relocation, monterey:       "ec37b14a1f45298f16f6a4c001b1240c10bc8bdeaa0eac187d2155cd14cef1d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec37b14a1f45298f16f6a4c001b1240c10bc8bdeaa0eac187d2155cd14cef1d0"
    sha256 cellar: :any_skip_relocation, catalina:       "ec37b14a1f45298f16f6a4c001b1240c10bc8bdeaa0eac187d2155cd14cef1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1d3b809e453e3754e920e6b915ebe9ad2562e7de23bcea9dff62e253681882"
  end

  depends_on "lua@5.1" => :test
  depends_on "lua@5.3" => :test
  depends_on "luajit" => :test unless Hardware::CPU.arm?
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
