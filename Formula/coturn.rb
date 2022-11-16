class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.6.0.tar.gz"
  sha256 "42206be7696014920dbe0ce309c602283ba71275eff51062e5456370fbacb863"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "http://turnserver.open-sys.org/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "0e884640634e8645b7f9f89daabed26f0d5e0d79ea37bc80f431ecd8f1427dc7"
    sha256 arm64_monterey: "e1a0067b4192a94c8ddc86840552d7c3953cde17a3d50104c0dbe1568a924aed"
    sha256 arm64_big_sur:  "ff40c2de37005b48c06cd1b4ea59d1b2df79d18e8d8fa87548f0202b04600ba5"
    sha256 monterey:       "eaad07d5a80ec74c125ed1a603a4480f1863f4b251884ed717292afac6a6e836"
    sha256 big_sur:        "5c55788efbc14bcedf41adf8862806afafb2fe076eccfdcb508f9295833682c8"
    sha256 catalina:       "e7b6165750bf7d0537fc5499e2291130b047951c0775a50d754d2ab5e0fea021"
    sha256 x86_64_linux:   "91e2e7206e39189c32627d7a4b38077ea234e1c74415bfc969519ee2f797c6bc"
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
