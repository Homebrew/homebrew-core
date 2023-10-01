class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20230911.tar.gz"
  sha256 "d08c23a0c793261cad1775795f258ca2149642eb19d3679a6bbb77582fa1d206"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d5aa75d72285be10742ddec81614df04b144edadcf98e68768ba5c794411f6bb"
    sha256 cellar: :any,                 arm64_ventura:  "c1cf1893f73e17e35d32dd654a653b054ab342adc8541a7c1ce40c0eb3616d66"
    sha256 cellar: :any,                 arm64_monterey: "722a0d4852476c3b1c829175325df6a3a25fb1944c6c189018945e1a6d20c73b"
    sha256 cellar: :any,                 arm64_big_sur:  "0ead2380ce5d009aa15b9413d4b7c7ee8b153be5c0940188c64e20e3f9415dd2"
    sha256 cellar: :any,                 sonoma:         "5d7adcf6907bf1e43fa612cd8dabcb8b3e2ecb73da99acf766c166fb7c34fa22"
    sha256 cellar: :any,                 ventura:        "3ab4983b69821739f67695ad5733cbb087e4b34ebe368bc0b5f1586d05aa7386"
    sha256 cellar: :any,                 monterey:       "557e13824af8c5963314e78f432c6ff802c2c490a849877caf2f0bb988a919fa"
    sha256 cellar: :any,                 big_sur:        "fd43b09d15522ae7cbe24d5e621e62dee5d5745c6619eaa4f3bb5e1d046d0e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8fbcafee63968330cb82eb32827463dd427424d4d7e6008e67491072c8ea95a"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

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
