class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20210510.tar.gz"
  sha256 "1ee6dad809a5bb22efb45e6dac767f7ce544ad652d353a93d7f26b605f69fe3f"
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
    sha256 cellar: :any,                 arm64_monterey: "24a1295818ce2374bdd64da3950d22310331c7ea45a284980c5e8ab62ca784e5"
    sha256 cellar: :any,                 arm64_big_sur:  "96e3a886e94e5db4b61c56abb5901143e33e532b4f12cd8da1a0afd92ec56fa1"
    sha256 cellar: :any,                 monterey:       "ccf212b3ea1a2556473dbc53bb72b7c0ac10e83e5d191cbe0290adb2185f43d1"
    sha256 cellar: :any,                 big_sur:        "e25634b88ac6fac6a0b9b10d0ba3f3b44d2becdef2459e95bfab7c4367035e9f"
    sha256 cellar: :any,                 catalina:       "6d969910e7805c1e4655a43321370e68f150efbb0825b12add00ecacdea75513"
    sha256 cellar: :any,                 mojave:         "c80ab72984ae032b2a04cd4ac8d4c759ca3fe8a0a33f6b0252b2556cf4a3cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8be8074cdf1059884413badca8589ed6581828e6cae3fa94e59404c1a63bea2"
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
