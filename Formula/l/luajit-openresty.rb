class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20240815.tar.gz"
  sha256 "9e59ec13c301c8b2855838b1248def49ef348a3e7563fabef677431706718145"
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
    sha256 cellar: :any,                 arm64_sequoia:  "9c2e139304a9347e068016dd6af5737aaa36cf3ed365588afa0b0fae3342783c"
    sha256 cellar: :any,                 arm64_sonoma:   "eac811d2f355e1846053077673547f049dd2c66eaad2ff7af9f54d2505a3a5dd"
    sha256 cellar: :any,                 arm64_ventura:  "52bf7212e60a2949c0228e2e2fec5e9734486c9a2b5266f183ae44f740d96a4e"
    sha256 cellar: :any,                 arm64_monterey: "c0b81bc5cd12816bf56cba7c0c43b791dd91612124e965cb9b66e80ae2f24a42"
    sha256 cellar: :any,                 sonoma:         "ce52d5d4eed84b74712f1e782d6e5b579261493ba6711b669203dcd87cf55ac5"
    sha256 cellar: :any,                 ventura:        "3e4c46f731bd3041222e133cc355fc3e8b2e58776de801c8ea7568a6edab3b68"
    sha256 cellar: :any,                 monterey:       "ab0c92ffc07e0245dc9a9d85d3c9b188f799368dd9dfd3e6bf74a8c9cd719df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03a571669285b5c8ccef6b1258febde897c5983f750bd39bc00201e8f495451"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    # Fix for clang >= 16, see https://github.com/LuaJIT/LuaJIT/issues/1266
    ENV.append "LDFLAGS", "-Wl,-no_deduplicate" if DevelopmentTools.clang_build_version >= 1600

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
    %W[#{lib}/lua #{share}/lua].each { |d| rm_r(d) }
  end

  test do
    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
