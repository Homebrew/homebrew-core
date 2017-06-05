class LuaAT51 < Formula
  # 5.2 is not fully backwards compatible so we must retain 2 Luas for now.
  # The transition has begun. Lua will now become Lua51, and Lua52 will become Lua.
  desc "Powerful, lightweight programming language (v5.1.5)"
  homepage "https://www.lua.org/"
  url "https://www.lua.org/ftp/lua-5.1.5.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/lua5.1/lua5.1_5.1.5.orig.tar.gz"
  sha256 "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333"
  revision 5

  bottle do
    cellar :any
    sha256 "550dd46b8849792fe96aa3878bdbe47972b8b39a3af8d7e3df15c2d0e2969ab8" => :sierra
    sha256 "bb5aed7c3b485ec7a102706d84dbcb9878cd2be20ac8cd686a0ef6eba9de7cba" => :el_capitan
    sha256 "1bc63e65986763d0501b26de2d712b055ae7d2e036b9257d48cb59fd6cb6e3c4" => :yosemite
  end

  keg_only :versioned_formula

  option "with-completion", "Enables advanced readline support"
  option "without-sigaction", "Revert to ANSI signal instead of improved POSIX sigaction"
  option "without-luarocks", "Don't build with Luarocks support embedded"

  # sigaction provided by posix signalling power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  if build.with? "completion"
    patch do
      url "http://lua-users.org/files/wiki_insecure/power_patches/5.1/sig_catch.patch"
      sha256 "221435dedd84a386e2d40454e6260a678286bfb7128afa18a4339e5fdda9c8f2"
    end
  end

  # completion provided by advanced readline power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  if build.with? "completion"
    patch do
      url "https://luajit.org/patches/lua-5.1.4-advanced_readline.patch"
      sha256 "dfd17e720d1079dcb64529af3e4fea4a4abc0115c934f365282a489d134cceb4"
    end
  end

  resource "luarocks" do
    url "https://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz"
    sha256 "68e38feeb66052e29ad1935a71b875194ed8b9c67c2223af5f4d4e3e2464ed97"
  end

  def install
    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS", "#{ENV.cflags} $(MYCFLAGS)"
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
      s.sub! "MYCFLAGS=-DLUA_USE_LINUX", "MYCFLAGS=-DLUA_USE_LINUX -fno-common"
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    # Fix paths in the .pc
    inreplace "etc/lua.pc" do |s|
      s.gsub! "prefix= /usr/local", "prefix=#{HOMEBREW_PREFIX}"
      s.gsub! "INSTALL_MAN= ${prefix}/man/man1", "INSTALL_MAN= ${prefix}/share/man/man1"
    end

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"

    (lib/"pkgconfig").install "etc/lua.pc"

    # This resource must be handled after the main install, since there's a lua dep.
    # Keeping it in install rather than postinstall means we can bottle.
    if build.with? "luarocks"
      resource("luarocks").stage do
        ENV.prepend_path "PATH", bin

        system "./configure", "--prefix=#{libexec}", "--rocks-tree=#{HOMEBREW_PREFIX}",
                              "--sysconfdir=#{etc}/luarocks51", "--with-lua=#{prefix}",
                              "--lua-version=5.1", "--versioned-rocks-dir"
        system "make", "build"
        system "make", "install"

        (share/"lua/5.1/luarocks").install_symlink Dir["#{libexec}/share/lua/5.1/luarocks/*"]
        bin.install_symlink libexec/"bin/luarocks"
        bin.install_symlink libexec/"bin/luarocks-admin"

        # This block ensures luarock exec scripts don't break across updates.
        inreplace libexec/"share/lua/5.1/luarocks/site_config.lua" do |s|
          s.gsub! libexec.to_s, opt_libexec.to_s
          s.gsub! include.to_s, "#{HOMEBREW_PREFIX}/include"
          s.gsub! lib.to_s, "#{HOMEBREW_PREFIX}/lib"
          s.gsub! bin.to_s, "#{HOMEBREW_PREFIX}/bin"
        end
      end
    end
  end

  def caveats; <<-EOS.undent
    Please be aware due to the way Luarocks is designed any binaries installed
    via Luarocks-5.2 AND 5.1 will overwrite each other in #{HOMEBREW_PREFIX}/bin.

    This is, for now, unavoidable. If this is troublesome for you, you can build
    rocks with the `--tree=` command to a special, non-conflicting location and
    then add that to your `$PATH`.
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
