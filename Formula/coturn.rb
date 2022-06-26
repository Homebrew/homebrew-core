class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.2/turnserver-4.5.2.tar.gz"
  sha256 "1cbef88cd4ab0de0d4d7011f4e7eaf39a344b485e9a272f3055eb53dd303b6e1"
  license "BSD-3-Clause"

  livecheck do
    url "http://turnserver.open-sys.org/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "670005d35ba1ef2baec0ef1a0e628d4cd9acf447a4417fea67606b230095cabe"
    sha256 arm64_big_sur:  "daebf6cf1b50a886b5f647c2331d0f9b811205148b04f03f60c79b0ef9b4b34f"
    sha256 monterey:       "a09a31c0b7e5c3ca820ab6765780bec19431f8267a167cd9a5bba2a084b53e30"
    sha256 big_sur:        "cbf4ffbe501023ff20d1d0798c0d3976c16fe29062fe18ce9e03230031c55f5b"
    sha256 catalina:       "9fcb011c5da93820c3b567ddb6488fb6812cd8d40477d167990023db5d510749"
    sha256 mojave:         "eef1e160c7951bd96f3f59a395d2474529fa03c12d380dd7daf9625435003c31"
    sha256 x86_64_linux:   "3b0cb1660a6f9c5f9b340f5d697b9cd0e853e0404f0479f31ca1340a8211e3a4"
  end

  depends_on "pkg-config" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--libdir=#{lib}",
                          "--docdir=#{doc}",
                          "--prefix=#{prefix}"

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  service do
    run [opt_bin/"turnserver", "-c", etc/"turnserver.conf"]
    keep_alive true
    error_log_path var/"log/coturn.log"
    log_path var/"log/coturn.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
