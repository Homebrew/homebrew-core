class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.8c.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.8c.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.8c.tar.gz"
  version "1.3.8c"
  sha256 "2a48f2ca338456e750d2373bf671025ed799e04e0baa16c7bb8dbfd67d8734d2"
  license "GPL-2.0-or-later"

  # Proftpd uses an incrementing letter after the numeric version for
  # maintenance releases. Versions like `1.2.3a` and `1.2.3b` are not alpha and
  # beta respectively. Prerelease versions use a format like `1.2.3rc1`.
  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "1855c711b92d4a36d8397111357c35aaa8c1a59472a2c650e086d22aee015f35"
    sha256 arm64_sonoma:  "b245d90b59026c93156b048d2321038183d835f0a0042bfcd6e5f6ccd780f1a1"
    sha256 arm64_ventura: "f9769026c0b9cbd52e52cb35e8900cc9a2b72acd77457cc074166041dccc38fb"
    sha256 sonoma:        "07fd7469de19bcfdd2fdf3dad73105f45f209f61f2a612aa85a6647c4682c8d5"
    sha256 ventura:       "c0cf5bcbf240ca802a6e35fe82f16a107d84f108b329c2402dcbad33ea948a33"
    sha256 x86_64_linux:  "80acad415435df2d07dcdf9e83ac3b4d8ef755f1d4b8e859d70e934f3f19c4f5"
  end

  uses_from_macos "libxcrypt"

  def install
    # fixes unknown group 'nogroup'
    # http://www.proftpd.org/docs/faq/linked/faq-ch4.html#AEN434
    inreplace "sample-configurations/basic.conf", "nogroup", "nobody"

    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{sbin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.deparallelize
    install_user = ENV["USER"]
    install_group = Utils.safe_popen_read("groups").split.first
    system "make", "all"
    system "make", "INSTALL_USER=#{install_user}", "INSTALL_GROUP=#{install_group}", "install"
  end

  service do
    run [opt_sbin/"proftpd"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match "ProFTPD Version #{version}", shell_output("#{opt_sbin}/proftpd -v")
  end
end
