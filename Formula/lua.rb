class Lua < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.4.4.tar.gz"
  sha256 "164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61"
  license "MIT"
  revision 1

  livecheck do
    url "https://www.lua.org/ftp/"
    regex(/href=.*?lua[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "801bc01f4821a3f69e7496a00d609d9669ac9f6cac0b7b5bfad540ca5c9317cc"
    sha256 cellar: :any,                 arm64_big_sur:  "685fff4864fabe098295955b09a5eb7696ea1d48f9d034b0d2c528b76a2ae64a"
    sha256 cellar: :any,                 monterey:       "05acee0902b938fe8d3154906f85fdd5b4d5947cecf5a1df8ea6d7cfe56ae038"
    sha256 cellar: :any,                 big_sur:        "61c13421560dc5875669c591c5b8fd7b9adff8f50fee07db6883f7c278f73c5a"
    sha256 cellar: :any,                 catalina:       "15ae93c61d7a2da10404dc915e76846fd0cd30421ad44989b9f83ea8fa9671ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9577e9329eec0de7cd8136e1557b62c135a0aa39e9f22a21be4cdee532d1e17"
  end

  uses_from_macos "unzip" => :build

  on_macos do
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/Homebrew/legacy-homebrew/pull/5043
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/11c8360432f471f74a9b2d76e012e3b36f30b871/lua/lua-dylib.patch"
      sha256 "a39e2ae1066f680e5c8bf1749fe09b0e33a0215c31972b133a73d43b00bf29dc"
    end
  end

  on_linux do
    depends_on "readline"

    # Add shared library for linux. Equivalent to the mac patch above.
    # Inspired from http://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0dcd11880c7d63eb395105a5cdddc1ca05b40f4a/lua/lua-so.patch"
      sha256 "522dc63a0c1d87bf127c992dfdf73a9267890fd01a5a17e2bcf06f7eb2782942"
    end
  end

  # Fix crash issue in luac when invoked with multiple files.
  # http://lua-users.org/lists/lua-l/2022-02/msg00113.html
  patch :DATA

  def install
    if OS.linux?
      # Fix: /usr/bin/ld: lapi.o: relocation R_X86_64_32 against `luaO_nilobject_' can not be used
      # when making a shared object; recompile with -fPIC
      # See http://www.linuxfromscratch.org/blfs/view/cvs/general/lua.html
      ENV.append_to_cflags "-fPIC"
    end

    # Substitute formula prefix in `src/Makefile` for install name (dylib ID).
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.gsub! "@OPT_LIB@", opt_lib if OS.mac?
      s.remove_make_var! "CC"
      s.change_make_var! "MYCFLAGS", ENV.cflags
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    os = if OS.mac?
      "macosx"
    else
      "linux-readline"
    end

    system "make", os, "INSTALL_TOP=#{prefix}"
    system "make", "install", "INSTALL_TOP=#{prefix}"

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    libs = %w[-llua -lm]
    libs << "-ldl" if OS.linux?
    (lib/"pkgconfig/lua.pc").write <<~EOS
      V= #{version.major_minor}
      R= #{version}
      prefix=#{HOMEBREW_PREFIX}
      INSTALL_BIN= ${prefix}/bin
      INSTALL_INC= ${prefix}/include/lua
      INSTALL_LIB= ${prefix}/lib
      INSTALL_MAN= ${prefix}/share/man/man1
      INSTALL_LMOD= ${prefix}/share/lua/${V}
      INSTALL_CMOD= ${prefix}/lib/lua/${V}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include/lua

      Name: Lua
      Description: An Extensible Extension Language
      Version: #{version}
      Requires:
      Libs: -L${libdir} #{libs.join(" ")}
      Cflags: -I${includedir}
    EOS

    # Fix some software potentially hunting for different pc names.
    bin.install_symlink "lua" => "lua#{version.major_minor}"
    bin.install_symlink "lua" => "lua-#{version.major_minor}"
    bin.install_symlink "luac" => "luac#{version.major_minor}"
    bin.install_symlink "luac" => "luac-#{version.major_minor}"
    (include/"lua#{version.major_minor}").install_symlink Dir[include/"lua/*"]
    lib.install_symlink shared_library("liblua", version.major_minor) => shared_library("liblua#{version.major_minor}")
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua#{version.major_minor}.pc"
    (lib/"pkgconfig").install_symlink "lua.pc" => "lua-#{version.major_minor}.pc"

    lib.install Dir[shared_library("src/liblua", "*")] if OS.linux?
  end

  def caveats
    <<~EOS
      You may also want luarocks:
        brew install luarocks
    EOS
  end

  test do
    assert_match "Homebrew is awesome!", shell_output("#{bin}/lua -e \"print ('Homebrew is awesome!')\"")
  end
end

__END__
diff --git a/src/luac.c b/src/luac.c
index f6db9cf..ba0a81e 100644
--- a/src/luac.c
+++ b/src/luac.c
@@ -156,6 +156,7 @@ static const Proto* combine(lua_State* L, int n)
    if (f->p[i]->sizeupvalues>0) f->p[i]->upvalues[0].instack=0;
   }
   luaM_freearray(L,f->lineinfo,f->sizelineinfo);
+  f->lineinfo = NULL;
   f->sizelineinfo=0;
   return f;
  }
