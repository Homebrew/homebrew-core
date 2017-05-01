class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  url "https://luajit.org/download/LuaJIT-2.0.5.tar.gz"
  sha256 "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979"

  head "https://luajit.org/git/luajit-2.0.git"

  bottle do
    sha256 "f9badbb9d75d07cb8a9297e874035a20c85795b43e80360e209b26dcb051fac9" => :sierra
    sha256 "38f869762b310ed4b62150517b7aac477230e3d86a2dbd4863859cb3f463bcbd" => :el_capitan
    sha256 "faa9c576ca33772c05060c680b6db988f8cde56b0a7c857b29bf4f0e53b23e14" => :yosemite
    sha256 "be43da3326342c34c0bb36b6f697154a13b9b86a854a320e7dc2f656f475e463" => :mavericks
  end

  devel do
    url "https://luajit.org/download/LuaJIT-2.1.0-beta2.tar.gz"
    sha256 "713924ca034b9d99c84a0b7b701794c359ffb54f8e3aa2b84fad52d98384cf47"

    # https://github.com/LuaJIT/LuaJIT/issues/180
    patch do
      url "https://github.com/LuaJIT/LuaJIT/commit/5837c2a2fb1ba6651.diff"
      sha256 "7b5d233fc3a95437bd1c8459ad35bba63825655f47951b6dba1d053df7f98587"
    end
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

    ENV.O2 # Respect the developer's choice.

    args = %W[PREFIX=#{prefix}]
    args << "XCFLAGS=-DLUAJIT_ENABLE_LUA52COMPAT" if build.with? "52compat"

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
      s.gsub! "Libs:",
              "Libs: -pagezero_size 10000 -image_base 100000000"
    end

    # Having an empty Lua dir in lib/share can mess with other Homebrew Luas.
    %W[#{lib}/lua #{share}/lua].each { |d| rm_rf d }
  end

  test do
    system "#{bin}/luajit", "-e", <<-EOS.undent
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
