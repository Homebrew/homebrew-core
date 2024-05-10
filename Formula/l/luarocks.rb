class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.11.0.tar.gz"
  sha256 "25f56b3c7272fb35b869049371d649a1bbe668a56d24df0a66e3712e35dd44a6"
  license "MIT"
  head "https://github.com/luarocks/luarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{/luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e48c1771b1c34f2e034398185e2d974ee41b4b0c6a91ce0ad56494918b7d5d13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e48c1771b1c34f2e034398185e2d974ee41b4b0c6a91ce0ad56494918b7d5d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e48c1771b1c34f2e034398185e2d974ee41b4b0c6a91ce0ad56494918b7d5d13"
    sha256 cellar: :any_skip_relocation, sonoma:         "de52191efb44bad1affa133ae0ab53c5f4fdbfaf9ac46686f6d5eb44af6bc071"
    sha256 cellar: :any_skip_relocation, ventura:        "de52191efb44bad1affa133ae0ab53c5f4fdbfaf9ac46686f6d5eb44af6bc071"
    sha256 cellar: :any_skip_relocation, monterey:       "de52191efb44bad1affa133ae0ab53c5f4fdbfaf9ac46686f6d5eb44af6bc071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48c1771b1c34f2e034398185e2d974ee41b4b0c6a91ce0ad56494918b7d5d13"
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

    return if HOMEBREW_PREFIX.to_s == "/usr/local"

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
    generate_completions_from_executable(bin/"luarocks", "completion")
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
