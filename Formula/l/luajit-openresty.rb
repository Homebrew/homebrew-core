class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20250826.tar.gz"
  sha256 "5a49743ad6ce4b7f19aac71b55a08052c1feb62750f051982082c12bf62f39c0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8e27728816882317d20801f3efa166dd68571810c57adb4474ca0b52621af17d"
    sha256 cellar: :any,                 arm64_sequoia: "35695f7aa831fb9e391f70a547bbcc536ae058ee40c48ede061728a2de98b946"
    sha256 cellar: :any,                 arm64_sonoma:  "40de5812247e80b6bdb4f7f53900eb378ec15fa74884df70f1fca6a8694c4f35"
    sha256 cellar: :any,                 arm64_ventura: "60d12c97a565761d032b1c50051df547b0f91c571f8ae1cbbaffdf6e4b5e8128"
    sha256 cellar: :any,                 sonoma:        "45536d4620249caaa02274a96f887405ade5f409625172beb659fe6c94a1190d"
    sha256 cellar: :any,                 ventura:       "e2ba7d279aa9de96a8b647919ed5c46a89ffdd66b4e79138d367d0f34875956b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa4374bb02d4f5451ca58bf6308feaed8e2163af4296bf0d3fa55c588748207f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950fca35524f185cb49a144933a6bc282572d9d60a268f43f0d460287b05baa4"
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
