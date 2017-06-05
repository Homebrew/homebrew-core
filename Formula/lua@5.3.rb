class LuaAT53 < Formula
  desc "Powerful, lightweight programming language"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.3.4.tar.gz"
  sha256 "f681aa518233bc407e23acf0f5887c884f17436f000d453b2491a9f11a52400c"
  revision 1

  bottle do
    cellar :any
    sha256 "19376afd63de40260f34006b8212432f2003fcbc2e7a1de28238e9bc67b89af0" => :sierra
    sha256 "970494abb3a2ce2f97710be65a76affdf7001c25ea00432514ae96523d6700b8" => :el_capitan
    sha256 "d0e79e1f4097bf550a488ec987e5e7316d3c4b95d4e5e588e348debcd0df7320" => :yosemite
  end

  keg_only :versioned_formula

  option "without-luarocks", "Don't build with Luarocks support embedded"

  resource "luarocks" do
    url "https://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz"
    sha256 "68e38feeb66052e29ad1935a71b875194ed8b9c67c2223af5f4d4e3e2464ed97"
  end

  def install
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS", "#{ENV.cflags} -DLUA_COMPAT_5_2 $(SYSCFLAGS) $(MYCFLAGS)"
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    # We ship our own pkg-config file as Lua no longer provide them upstream.
    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    (lib/"pkgconfig/lua.pc").write pc_file

    # This resource must be handled after the main install, since there's a lua dep.
    # Keeping it in install rather than postinstall means we can bottle.
    if build.with? "luarocks"
      resource("luarocks").stage do
        ENV.prepend_path "PATH", bin
        lua_prefix = prefix

        system "./configure", "--prefix=#{libexec}", "--rocks-tree=#{HOMEBREW_PREFIX}",
                              "--sysconfdir=#{etc}/luarocks53", "--with-lua=#{lua_prefix}",
                              "--lua-version=5.3", "--versioned-rocks-dir"
        system "make", "build"
        system "make", "install"

        (share/"lua/5.3/luarocks").install_symlink Dir["#{libexec}/share/lua/5.3/luarocks/*"]
        bin.install_symlink libexec/"bin/luarocks"
        bin.install_symlink libexec/"bin/luarocks-admin"

        # This block ensures luarock exec scripts don't break across updates.
        inreplace libexec/"share/lua/5.3/luarocks/site_config.lua" do |s|
          s.gsub! libexec.to_s, opt_libexec
          s.gsub! include.to_s, "#{HOMEBREW_PREFIX}/include"
          s.gsub! lib.to_s, "#{HOMEBREW_PREFIX}/lib"
          s.gsub! bin.to_s, "#{HOMEBREW_PREFIX}/bin"
        end
      end
    end
  end

  def pc_file; <<-EOS.undent
    V= 5.3
    R= 5.3.3
    prefix=#{HOMEBREW_PREFIX}
    INSTALL_BIN= ${prefix}/bin
    INSTALL_INC= ${prefix}/include/lua-5.3
    INSTALL_LIB= ${prefix}/lib
    INSTALL_MAN= ${prefix}/share/man/man1
    INSTALL_LMOD= ${prefix}/share/lua/${V}
    INSTALL_CMOD= ${prefix}/lib/lua/${V}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include/lua-5.3

    Name: Lua
    Description: An Extensible Extension Language
    Version: 5.3.3
    Requires:
    Libs: -L${libdir} -llua.5.3 -lm
    Cflags: -I${includedir}
    EOS
  end

  test do
    system "#{bin}/lua", "-e", "print ('Ducks are cool')"

    if File.exist?(bin/"luarocks")
      mkdir testpath/"luarocks"
      system bin/"luarocks", "install", "moonscript", "--tree=#{testpath}/luarocks"
      assert File.exist? testpath/"luarocks/bin/moon"
    end
  end
end
