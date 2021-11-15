class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/v1.3.7c.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.7c.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.7c.tar.gz"
  version "1.3.7c"
  sha256 "7070968b9b6cf614ce7f756c8c1a66c32c1afa4f961784a62301790a801400da"
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
    sha256 arm64_monterey: "6661c5df232e3e2f8e0609fad62bcaaee63d626d831752bdcdfb8d84a9d124b2"
    sha256 arm64_big_sur:  "0429e46d82d193acdb80410a84c9d00d26e8a0510b0b5ec29ab7aa543d41f46a"
    sha256 monterey:       "add62615c7234194288b6d780955ed00e7bbeb5b854765acc5a380ac1d203fd2"
    sha256 big_sur:        "1a4d0410392d18250ea4f29fe056e3e647345bb940f3b918fae448fe16bb4562"
    sha256 catalina:       "e40fb1eb3c76ff530fbf95275200defdcc38bb16ed3de8dfe90f5bcdf0965ae4"
    sha256 mojave:         "c6143e56532ccfe54ce0ef2889a356656d7c9800c93e18cdafd8d5430be3a43c"
    sha256 x86_64_linux:   "9539952d41b01326e358bc32ae8aa96297154b992e5359b5ee29e3a4b1f20036"
  end

  def install
    # fixes unknown group 'nogroup'
    # http://www.proftpd.org/docs/faq/linked/faq-ch4.html#AEN434
    inreplace "sample-configurations/basic.conf", "nogroup", "nobody"

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.deparallelize
    install_user = ENV["USER"]
    install_group = `groups`.split[0]
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
