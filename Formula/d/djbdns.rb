class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"
  license :public_domain

  livecheck do
    url "https://cr.yp.to/djbdns/install.html"
    regex(/href=.*?djbdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:    "0be5754ae44ee59873e53f476c3da544b31aabf8107d97817cebb77c75ae14e9"
    sha256 arm64_sequoia:  "1e36d75e37885c9b6e9ecfc4fcebd3768092dc1f512bf6a52014d5edb2b30e5f"
    sha256 arm64_sonoma:   "8a9f3afe0b64bc8e2b08a1bb14df5d5b642d1e61fb34f0fe88807ea496d599a9"
    sha256 arm64_ventura:  "c22d9f6511649edb5496741a4c3e378cb94fd73fd75321272ed1a9c15f9766f4"
    sha256 arm64_monterey: "eb8f1b169c2ef3b24defe00ef952b8dab42b45d42517bce471aa6e9016c7b4b6"
    sha256 arm64_big_sur:  "62ab5e22e0c15787a98c84f23905dd569067cd4376dc8c472509ac5ee5d24955"
    sha256 sonoma:         "362cd5926caa703da34cf8221e86e1019fa197d1762a9531da088642001e806d"
    sha256 ventura:        "5acb70859d01c8bc6e7ca3aaecfee0ff9a2791bbd3bcebf7de1a4937c3e18878"
    sha256 monterey:       "e31e528e17b73be225ea467a43d2e1c997bfac8a9adb723d7e3c48595f13ca5c"
    sha256 big_sur:        "1231622a14007c9ec76ef137a5e1a42a30ce4192b0fbba0cf768f981090059ce"
    sha256 catalina:       "5b473b664d7370f2e838bd496555841e20a8ef13aaeee6b312fc6501911b7fe0"
    sha256 arm64_linux:    "064d2f4f4d5fb2c18488c5dc23d4803da0bba3ca4b4be16de6dc736c8e08bf1b"
    sha256 x86_64_linux:   "02f2234288612b979b6e5947072123ee049558864042839f5c929300d0fbb96f"
  end

  depends_on "daemontools"
  depends_on "ucspi-tcp"

  on_linux do
    depends_on "fakeroot" => :build
  end

  def install
    inreplace "hier.c", 'c("/"', "c(auto_home"
    inreplace "dnscache-conf.c", "/etc/dnsroots", "#{etc}/dnsroots"

    # Write these variables ourselves.
    rm %w[conf-home conf-ld conf-cc]
    (buildpath/"conf-home").write prefix
    (buildpath/"conf-ld").write "gcc"

    usr = if OS.mac? && MacOS.sdk_path_if_needed
      "#{MacOS.sdk_path}/usr"
    else
      "/usr"
    end
    # `-Wno-implicit-function-declaration` fixes compile with newer Clang
    (buildpath/"conf-cc").write "gcc -O2 -include #{usr}/include/errno.h -Wno-implicit-function-declaration"

    bin.mkpath
    (prefix/"etc").mkpath # Otherwise "file does not exist"

    # Use fakeroot on Linux because djbdns checks for setgroups permissions
    # that are limited in CI.
    if OS.mac?
      system "make", "setup", "check"
    else
      system "fakeroot", "make", "setup", "check"
    end
  end

  test do
    # Use example.com instead of localhost, because localhost does not resolve in all cases
    assert_match(/\d+\.\d+\.\d+\.\d+/, shell_output("#{bin}/dnsip example.com").chomp)
  end
end
