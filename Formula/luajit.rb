class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  url "https://luajit.org/download/LuaJIT-2.0.5.tar.gz"
  sha256 "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979"

  bottle do
    rebuild 1
    sha256 "9093866c951b8ec11c896fa2508043081322fcd6a336e6f7710f20b39e535561" => :mojave
    sha256 "ec3757b184301eba2c0364b7c93a9dbb12357ed045aef02246cab9068d0c14d5" => :high_sierra
    sha256 "2bec1138cd0114e4df5c56cd14ec2cc88f6e397c1fb7dc1e1763926670645078" => :sierra
    sha256 "c6090283a2708cf2fb818d2f33845d80d6b01d236ce1306b6f56d7c6879b0b34" => :el_capitan
  end

  devel do
    url "https://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz"
    sha256 "1ad2e34b111c802f9d0cdf019e986909123237a28c746b21295b63c9e785d9c3"

    option "with-gc64", "Build with 64-bit support"
  end

  head do
    url "https://luajit.org/git/luajit-2.0.git", :branch => "v2.1"

    option "with-gc64", "Build with 64-bit support"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debugging symbols"
  option "with-52compat", "Build with additional Lua 5.2 compatibility"

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

    ENV.O2 # Respect the developer's choice.

    args = %W[PREFIX=#{prefix}]

    cflags = []
    cflags << "-DLUAJIT_ENABLE_LUA52COMPAT" if build.with? "52compat"
    cflags << "-DLUAJIT_ENABLE_GC64" if !build.stable? && build.with?("gc64")

    args << "XCFLAGS=#{cflags.join(" ")}" unless cflags.empty?

    # This doesn't yet work under superenv because it removes "-g"
    args << "CCDEBUG=-g" if build.with? "debug"

    # The development branch of LuaJIT normally does not install "luajit".
    args << "INSTALL_TNAME=luajit" if build.devel?

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
      if build.without? "gc64"
        s.gsub! "Libs:",
                "Libs: -pagezero_size 10000 -image_base 100000000"
      end
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
