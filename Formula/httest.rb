class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality"
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.23/httest-2.4.23.tar.gz"
  sha256 "52a90c9719b35226ed1e26a5262df0d14aeb63b258187656bf1eb30ace53232c"
  revision 1

  bottle do
    cellar :any
    sha256 "871daf0bb3f8c21e567457bb46b57b5ba5cba1afc9d9df6633a83e44053d87b5" => :high_sierra
    sha256 "c77a3177e4662908fc013d586239d306f8e672c713431ee3ffc5ff8f07c06e63" => :sierra
    sha256 "263b8f5d1c78afaff3717258e9d0949bab1eb1a0d0e43d89663bd17ce27c7bc8" => :el_capitan
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua@5.1" => :recommended
  depends_on "nghttp2" => :recommended
  depends_on "spidermonkey" => :recommended

  deprecated_option "without-lua" => "without-lua@5.1"

  def install
    inreplace "configure",
      "else LUA_LIB_PATH=\"-L${withval}\"; LUA_INCLUDES=\"-I${withval}\"; LUA_LIB=\"-llua\"; fi",
      "else LUA_LIB_PATH=\"-L${withval}/lib\"; LUA_INCLUDES=\"-I${withval}/include/lua-5.1\"; LUA_LIB=\"-llua.5.1\"; fi"

    # Fix "fatal error: 'pcre/pcre.h' file not found"
    # Reported 9 Mar 2017 https://sourceforge.net/p/htt/tickets/4/
    (buildpath/"brew_include").install_symlink Formula["pcre"].opt_include => "pcre"
    ENV.prepend "CPPFLAGS", "-I#{buildpath}/brew_include"

    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for libxml2
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--enable-html-module",
      "--enable-xml-module",
      "--with-apr=#{Formula["apr"].opt_bin}",
      "--with-lua=#{Formula["lua@5.1"].opt_prefix}",
    ]
    args << "--enable-lua-module" if build.with? "lua@5.1"
    args << "--enable-h2-module" if build.with? "nghttp2"
    args << "--enable-js-module" if build.with? "spidermonkey"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.htt").write <<~EOS
      CLIENT 5
        _TIME time
      END
    EOS
    system bin/"httest", "--debug", testpath/"test.htt"
  end
end
