class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality"
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.22/httest-2.4.22.tar.gz"
  sha256 "b63ab35ee500cf7985df7c365aca20f41dde0bab585f67865cf588b2ff1206fb"

  bottle do
    cellar :any
    sha256 "a87b607ce09404d86f282acb62eb0481c8a2932396453fa4c9ce7cf1fb353d2d" => :high_sierra
    sha256 "639ccc35988ae5df41ee3774343df00c447698453fcd9958a247ce81f0a24de2" => :sierra
    sha256 "8d69771ad06e4d2e2bdd692255d8e55f272338414e5998b106dac669d96bba96" => :el_capitan
    sha256 "9d738b97356995a8e8cf68aa25cb7ebba74c659ffbf0d8f33f9a8984482ec36a" => :yosemite
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
