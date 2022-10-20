class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/v1.3.7e.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.7e.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.7e.tar.gz"
  version "1.3.7e"
  sha256 "6e716a3b53ee069290399fce6dccf4c229fafe6ec2cb14db3778b7aa3f9a8c92"
  license "GPL-2.0-or-later"

  # Proftpd uses an incrementing letter after the numeric version for
  # maintenance releases. Versions like `1.2.3a` and `1.2.3b` are not alpha and
  # beta respectively. Prerelease versions use a format like `1.2.3rc1`.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "af16db8ab4261d0daa4ee5e5f51046045a20b017dc854adb1421f26407688982"
    sha256 arm64_big_sur:  "07fadba73d0440b08846a2e3a5ddca07b2b398ef949d71931acf384c7d607181"
    sha256 monterey:       "1cb51eb56dab1081f6c64ac75904e38e59065ba1ec78f43cd761ab88c0de0117"
    sha256 big_sur:        "429dc14ebcbf7b31e4073578522fab149c08abc8986ca39b9e0c6a698e2c4a69"
    sha256 catalina:       "23aaeb1f2c8f08fd561cb9e2a4fac400b1176365726bb3044487a0658b0cdb24"
    sha256 x86_64_linux:   "f88d9dbcb70b79b0c008e23ddfeb7f72211116c7d89759dc9324dca3d348b3ed"
  end

  uses_from_macos "libxcrypt"

  def install
    # fixes unknown group 'nogroup'
    # http://www.proftpd.org/docs/faq/linked/faq-ch4.html#AEN434
    inreplace "sample-configurations/basic.conf", "nogroup", "nobody"

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.deparallelize
    install_user = ENV["USER"]
    install_group = Utils.safe_popen_read("groups").split.first
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
    assert_match version.to_s, shell_output("#{opt_sbin}/proftpd -v")
  end
end
