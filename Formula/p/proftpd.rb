class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.8a.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.8a.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.8a.tar.gz"
  version "1.3.8a"
  sha256 "56093b890a712220b09b98e29de2974a590e8fae6b36ed78c698a90945466aaf"
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
    sha256 arm64_sonoma:   "70ae4307ed03498ede79b699e1d2fae0d98a40c7237bb3aecffcfb09d0cd1c35"
    sha256 arm64_ventura:  "94f4bb9d471e2d8f1d0b4c6ff408fd4862b4dc230ff2b5589e7c98737f9785ec"
    sha256 arm64_monterey: "40d2ce79ea6e42f07359317d5aed04dfd34a954cd6063426bb7cd0bfa438721b"
    sha256 sonoma:         "5b064ab61b945592a8995ccd44f8c892ba99d8394fde848ddb880f2ce988be02"
    sha256 ventura:        "45d54b6c6753e6083e52e6d2e4e71f1aef53e336a10f9b0cf26701b417b37d44"
    sha256 monterey:       "8baf84af1adf48600310982322622271f03054aa893a2686363ab778b508211e"
    sha256 x86_64_linux:   "3e57fb237e35a39e8ce9116a183f5e13b042d0171d45cee7ff9e535da51d6f8a"
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
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match "ProFTPD Version #{version}", shell_output("#{opt_sbin}/proftpd -v")
  end
end
