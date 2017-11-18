class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality"
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.22/httest-2.4.22.tar.gz"
  sha256 "b63ab35ee500cf7985df7c365aca20f41dde0bab585f67865cf588b2ff1206fb"

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
  depends_on "lua"

  def install
    # Fix "fatal error: 'pcre/pcre.h' file not found"
    # Reported 9 Mar 2017 https://sourceforge.net/p/htt/tickets/4/
    (buildpath/"brew_include").install_symlink Formula["pcre"].opt_include => "pcre"
    ENV.prepend "CPPFLAGS", "-I#{buildpath}/brew_include"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-apr=#{Formula["apr"].opt_bin}",
                          "--enable-lua-module"
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
