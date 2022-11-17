class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20220915.tar.gz"
  sha256 "a6104d4fa342d864ae00cb3313b07091af02dc61294b1d8fce1e17779998b497"
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
    sha256 cellar: :any,                 arm64_ventura:  "4833addd942e8620416ac0b4fbb33960888a7bef6579dc93f70a3188a87c046e"
    sha256 cellar: :any,                 arm64_monterey: "f0c9437a16aa8a274bd9730d48459dcb5604968e24f899db25d3bb3c714d36f2"
    sha256 cellar: :any,                 arm64_big_sur:  "edad4431c0d4966b8a6b2b1224d09d4aef59616dc31abff7573d6088a7ce52fa"
    sha256 cellar: :any,                 ventura:        "308afce35301ee87ba1b19dac065ae156ec0cab0e232505f3b33ec708d05d938"
    sha256 cellar: :any,                 monterey:       "399ad9f89123000e5882cab46c65ffb70d2c93727ebec313f81d7d9d07f30ca7"
    sha256 cellar: :any,                 big_sur:        "24881920f33cf53d1fc65680b757fb2679408a730bb591fa94a9ccf5b954c1ee"
    sha256 cellar: :any,                 catalina:       "166be848fc4413a3c2b7d43aba43492354421c18e84f1fa7dfe9f800010b4188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd932ebb29d3bce24d1212db7e4d20201115ed0517669031f0210e826ba8ec8"
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
