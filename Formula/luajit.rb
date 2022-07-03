# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  url "https://github.com/LuaJIT/LuaJIT/archive/4c2441c16ce3c4e312aaefecc6d40c4fe21de97c.tar.gz"
  # Use the version scheme `2.1.0-beta3-yyyymmdd.x` where `yyyymmdd` is the date of the
  # latest commit at the time of updating, and `x` is the number of commits on that date.
  version "2.1.0-beta3-20220623.2"
  sha256 "e46561743772f2e338e9dbdc1a6b7c8210688e9d25dd823f93890a44a8d30b16"
  license "MIT"
  head "https://luajit.org/git/luajit-2.0.git", branch: "v2.1"

  livecheck do
    url "https://github.com/LuaJIT/LuaJIT/commits/v2.1"
    regex(/<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]/im)
    strategy :page_match do |page, regex|
      newest_date = nil
      commit_count = 0
      page.scan(regex).map do |match|
        date = Date.parse(match[0])
        newest_date ||= date
        break if date != newest_date

        commit_count += 1
      end
      next if newest_date.blank? || commit_count.zero?

      # The main LuaJIT version is rarely updated, so we recycle it from the
      # `version` to avoid having to fetch another page.
      version.to_s.sub(/\d+\.\d+$/, "#{newest_date.strftime("%Y%m%d")}.#{commit_count}")
    end
  end

  bottle do
    rebuild 5
    sha256 cellar: :any,                 monterey:     "351112e416f845b313dc71cb2a54d349330a6c676ea381d30f5d9d1c676e795c"
    sha256 cellar: :any,                 big_sur:      "5f5d205e4e49f015379ef230d3a068a2fa3079ab42341a473297290fa654a782"
    sha256 cellar: :any,                 catalina:     "ee0c6394223cff8789452c0fc413d91cefeea1a3b5b5e2e39931620e8037c628"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "67663e6413774ef4b8be6678e389a6adb8e23ef50f52d5bb6d44f2b1069f6e8a"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    # Also: Set `LUA_ROOT` to `HOMEBREW_PREFIX` so that Luajit can find modules outside its own keg.
    # This should avoid the need for writing env scripts that specify `LUA_PATH` or `LUA_CPATH`.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(/-march=\w+\s?/, "")
      f.gsub!(/^(  TARGET_XCFLAGS\+= -DLUA_ROOT=)\\"\$\(PREFIX\)\\"$/, "\\1\\\"#{HOMEBREW_PREFIX}\\\"")
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    args = %W[
      PREFIX=#{prefix}
      XCFLAGS=-DLUAJIT_ENABLE_GC64
    ]

    system "make", "amalg", *args
    system "make", "install", *args

    # v2.1 branch doesn't install symlink for luajit.
    # This breaks tools like `luarocks` that require the `luajit` bin to be present.
    bin.install_symlink bin.glob("luajit-*").first => "luajit"

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/shared_library("libluajit-5.1") => shared_library("libluajit")
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
    end

    # Having an empty Lua dir in lib/share can mess with other Homebrew Luas.
    [lib/"lua", share/"lua"].map(&:rmtree)
  end

  test do
    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
    # Check that LuaJIT can find its own `jit.*` modules
    system bin/"luajit", "-l", "jit.bcsave", "-e", ""
  end
end
