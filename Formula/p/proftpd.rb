class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.9.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.9.tar.gz/"
  sha256 "4a5f13b666226813b4da0ade34535d325e204ab16cf8008c7353b1b5a972f74b"
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
    sha256 arm64_sequoia: "ff2411cecf1ed7c49a47ab0f432baa31b5e27b9483cc8404179fe4454d0ce186"
    sha256 arm64_sonoma:  "47c7285cac71305d24a585f231085421221949f7e41da52c4f2d807b5c63e68d"
    sha256 arm64_ventura: "556493e923eed83521dbf6cc4cdc92f9feb3ef635e7d00b01eabd0ade523abdb"
    sha256 sonoma:        "56b20b6b84180fff26fa7f09d6a09a5622912eeafbe47edbdab48dc17ed5d0aa"
    sha256 ventura:       "cbaa7686fe01b1ee6e707a15cc997cf28b34b9d6ef963ec62680f06cfb322518"
    sha256 arm64_linux:   "183e2f2eae6a4d81a6d6c692c6fb4c367ffa0f6a1c2a3dc083d4750e7bfea96d"
    sha256 x86_64_linux:  "3f9384ff1b02d1c0374398868a325d671d60bd9e8a47f7943dd4b7f799c83759"
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
