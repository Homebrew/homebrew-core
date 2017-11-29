class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality"
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.23/httest-2.4.23.tar.gz"
  sha256 "52a90c9719b35226ed1e26a5262df0d14aeb63b258187656bf1eb30ace53232c"

  bottle do
    cellar :any
    sha256 "f10e8bb19fd3e2336f38be2dd6572dee152c0e89a0a46f2c46d3082c9eb82588" => :high_sierra
    sha256 "e831dbdbebadc52f9cb76759ccf28564d74748a08a6074056b5b33b299e16e67" => :sierra
    sha256 "230797d386a267bbe2cc60de874f9da4cb58abcebd6d420d768a2d7e9a0a7e51" => :el_capitan
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua" => :recommended
  depends_on "nghttp2" => :recommended
  depends_on "spidermonkey" => :recommended

  def install
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
    ]
    args << "--enable-lua-module" if build.with? "lua"
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
