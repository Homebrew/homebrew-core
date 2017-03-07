class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality."
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.19/httest-2.4.19.tar.gz"
  sha256 "0cf2454de50995c14c460040cdf29863dd49082805e2bc61fb6938a7042b2dbd"

  bottle do
    cellar :any
    sha256 "397795cc9e8bddc8f8a3164530eb1437735285dc3d0710868249a4e1faf28d89" => :sierra
    sha256 "02ccd19470885531820f61c1734d4f024eac78b548247a68fa5f1be9f20a5501" => :el_capitan
    sha256 "60b78ecb5540a2bc3d7eb7af04280943ea16c64e97f6e5d048219fb1789260aa" => :yosemite
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua"

  def install
    (buildpath/"brew_include").install_symlink Formula["pcre"].opt_include => "pcre"
    ENV.prepend "CPPFLAGS", "-I#{buildpath}/brew_include"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-apr=#{Formula["apr"].opt_bin}",
                          "--enable-lua-module"
    system "make", "install"
  end

  test do
    (testpath/"test.htt").write <<-EOS.undent
      CLIENT 5
        _TIME time
      END
    EOS
    system bin/"httest", "--debug", testpath/"test.htt"
  end
end
