class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20210510.tar.gz"
  version "20210510"
  sha256 "1ee6dad809a5bb22efb45e6dac767f7ce544ad652d353a93d7f26b605f69fe3f"
  license "MIT"
  head "https://github.com/openresty/luajit2.git", branch: "v2.1-agentzh"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1206d1abe22d5ce6c2be8899c5829172f25264ea2b888926116c0b5aa21eedbd"
    sha256 cellar: :any, big_sur:       "c4058bf652e63d1fa42b1453a7f1f100f1c8702c874d778693318d2e903ce465"
    sha256 cellar: :any, catalina:      "31b27b774a37110992c1f4430f2a5b5059dca29dd05e744654a16ae06adee76d"
    sha256 cellar: :any, mojave:        "c9ab34e0917b1574651b031fc1d4488e91777e77ae9661d9afe30c0444996a5e"
  end

  keg_only "it conflicts with the LuaJIT formula"

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
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

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/"libluajit-5.1.dylib" => "libluajit.dylib"
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
    %W[#{lib}/lua #{share}/lua].each { |d| rm_rf d }
  end

  test do
    system "#{bin}/luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
