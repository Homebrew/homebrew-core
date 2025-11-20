class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.12.2.tar.gz"
  sha256 "b0e0c85205841ddd7be485f53d6125766d18a81d226588d2366931e9a1484492"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{/luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7bc6365426b00c812417e7449477dd2ac13fd5fae072dfe7be78d5449225b195"
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
      deps
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
