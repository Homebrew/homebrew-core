class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality"
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.23/httest-2.4.23.tar.gz"
  sha256 "52a90c9719b35226ed1e26a5262df0d14aeb63b258187656bf1eb30ace53232c"
  revision 1

  bottle do
    cellar :any
    sha256 "688badfeee292b330513c5b2f82553a768259dfe71b440ab1d59c1b7052728c1" => :high_sierra
    sha256 "b4e4fdc797548136fe2a7c7e2dd5b65a40862c6f13b48e2a89d66cfc45a4dc64" => :sierra
    sha256 "83fe0d8248e25a67cac3948d3debbdb754940b7ebb85ee8f3d7104bb3ef6bc38" => :el_capitan
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
