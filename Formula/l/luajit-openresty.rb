class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20231006.tar.gz"
  sha256 "41530b3f00d3f284e771cfd09add2a0c672f1214f8780644ca9261da9e4d9310"
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
    sha256 cellar: :any,                 arm64_sonoma:   "bdfc85aaf23979a1b7c6cf05d19038bb9e4363af988874fbf92fc565f01c0971"
    sha256 cellar: :any,                 arm64_ventura:  "e4e99e03dcbf46e53862677225ea87b0ef45538e91e7fd157f327eb81d1e822d"
    sha256 cellar: :any,                 arm64_monterey: "4593fe8bdb1d347bbe43e6356930fdcd74bb310ef909b64154fac10cbe5485a7"
    sha256 cellar: :any,                 sonoma:         "d81ccb649ac54bf4743d286c33289619839eb0d9ef3c85c69ef8e588914e6af1"
    sha256 cellar: :any,                 ventura:        "4e88d1dc14b49d18951ed50663c879d315c661b0da8c7aefd689dbb5ade6c09b"
    sha256 cellar: :any,                 monterey:       "c645ba5334381818b317e1e09a5a8e0f523f2c1458031ff4908c8a9dc56e2607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f2e537cbdc9d3e8c4c6b965f4de06cb4eee643815a2cfdd98f71655f0a5b99"
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
