class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20230410.tar.gz"
  sha256 "77bbcbb24c3c78f51560017288f3118d995fe71240aa379f5818ff6b166712ff"
  license "MIT"
  version_scheme 1
  head "https://github.com/openresty/luajit2.git", branch: "v2.1-agentzh"

  # The latest LuaJIT release is unstable (2.1.0-beta3, from 2017-05-01) and
  # OpenResty is making releases using the latest LuaJIT Git commits. With this
  # in mind, the regex below is very permissive and will match any tags
  # starting with a numeric version, ensuring that we match unstable versions.
  # We should consider restricting the regex to stable versions if it ever
  # becomes feasible in the future.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[^{}]*)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e534584c7c3b7eb3a137649e7e6801b98799a1d863466d8db8b09343134f2a9b"
    sha256 cellar: :any,                 arm64_monterey: "2e11555a5d4d0be559d01145726d068c4125172532ac5f51bb849f761fe80650"
    sha256 cellar: :any,                 arm64_big_sur:  "83badf175a69ce7883c267ab0307204358fa5c705f5e7a004ac8088afb69a15c"
    sha256 cellar: :any,                 ventura:        "02a45febeb8a172ebba48830de9f9c80853efe1382c9723e51b13f40c85b3fc0"
    sha256 cellar: :any,                 monterey:       "99fdd703af20ec78bd845c3d6bf6f47b8c150ec425985549e8cd6389afc26628"
    sha256 cellar: :any,                 big_sur:        "c5ed3c1c9b13b347a14fcb35c053fab22a1cca47a382cc0aa323e6d357dd61dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db66a26e9cbbce3acb24f279da334ebae69d6f319a3f93425aea13490a75c86"
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
