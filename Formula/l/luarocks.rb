class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.11.1.tar.gz"
  sha256 "c3fb3d960dffb2b2fe9de7e3cb004dc4d0b34bb3d342578af84f84325c669102"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{/luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0cf000ae5081eff2d53ed7fe0e7becdb59151b022afe68502954f52bae71b555"
  end

  depends_on "luajit" => :test
  depends_on "lua"

  uses_from_macos "unzip"

  def install
    # Fix the lua config file missing issue for luarocks-admin build
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}"
    system "make", "install"
    generate_completions_from_executable(bin/"luarocks", "completion")

    # Make bottles uniform to make an `:all` bottle
    luaversion = Formula["lua"].version.major_minor
    inreplace_files = %w[
      cmd/config
      cmd/which
      core/cfg
      core/path
      deps
      loader
    ].map { |file| share/"lua"/luaversion/"luarocks/#{file}.lua" }
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    luas = [
      Formula["lua"],
      Formula["luajit"],
    ]

    luas.each do |lua|
      luaversion, luaexec = case lua.name
      when "luajit" then ["5.1", lua.opt_bin/"luajit"]
      else [lua.version.major_minor, lua.opt_bin/"lua-#{lua.version.major_minor}"]
      end

      ENV["LUA_PATH"] = "#{testpath}/share/lua/#{luaversion}/?.lua"
      ENV["LUA_CPATH"] = "#{testpath}/lib/lua/#{luaversion}/?.so"

      system bin/"luarocks", "install",
                                "luafilesystem",
                                "--tree=#{testpath}",
                                "--lua-dir=#{lua.opt_prefix}"

      system luaexec, "-e", "require('lfs')"

      case luaversion
      when "5.1"
        (testpath/"lfs_#{luaversion}test.lua").write <<~LUA
          require("lfs")
          lfs.mkdir("blank_space")
        LUA

        system luaexec, "lfs_#{luaversion}test.lua"
        assert_predicate testpath/"blank_space", :directory?,
          "Luafilesystem failed to create the expected directory"
      else
        (testpath/"lfs_#{luaversion}test.lua").write <<~LUA
          require("lfs")
          print(lfs.currentdir())
        LUA

        assert_match testpath.to_s, shell_output("#{luaexec} lfs_#{luaversion}test.lua")
      end
    end
  end
end
