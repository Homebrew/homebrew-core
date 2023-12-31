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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "feb3d3a0d197a49b30c6cf97f378edaabc28091b296c20944a604ab605a74186"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feb3d3a0d197a49b30c6cf97f378edaabc28091b296c20944a604ab605a74186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb3d3a0d197a49b30c6cf97f378edaabc28091b296c20944a604ab605a74186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feb3d3a0d197a49b30c6cf97f378edaabc28091b296c20944a604ab605a74186"
    sha256 cellar: :any_skip_relocation, sonoma:         "688737ba89f9cdb348edf15e80fb2f3e9e4dae06e16677526c50fea2198f8739"
    sha256 cellar: :any_skip_relocation, ventura:        "688737ba89f9cdb348edf15e80fb2f3e9e4dae06e16677526c50fea2198f8739"
    sha256 cellar: :any_skip_relocation, monterey:       "688737ba89f9cdb348edf15e80fb2f3e9e4dae06e16677526c50fea2198f8739"
    sha256 cellar: :any_skip_relocation, big_sur:        "688737ba89f9cdb348edf15e80fb2f3e9e4dae06e16677526c50fea2198f8739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb3d3a0d197a49b30c6cf97f378edaabc28091b296c20944a604ab605a74186"
  end

  depends_on "luajit" => :test
  depends_on "lua"

  uses_from_macos "unzip"

  def install
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
