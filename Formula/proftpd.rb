class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/v1.3.7b.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.7b.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.7b.tar.gz"
  version "1.3.7b"
  sha256 "d1560d191f81ee9c0b295aea76f44e2d6c0b2d0f912c835c80bc1bbca473471e"
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
    sha256 arm64_big_sur: "469d2909145df007d34b0a44f93d1b09a0d20d20ccf5d9afaba1bb4d4c6b45d7"
    sha256 big_sur:       "0497946296c3f5d5a50fb87b35d0520488121f3fba13287e71a3078f507167c8"
    sha256 catalina:      "e169c92a92a8ba51c155c5a4010724ac8c657dc3820f7545c1cf4d2deac8454c"
    sha256 mojave:        "9ead7ace3404b1a4dbe464f4dea92ec59b00b57c24a7ba19bea6de51a5a334eb"
    sha256 x86_64_linux:  "60c7cb5c776bc40b9b9d989c87cb4c55288fdd482a81856b02daa2761b2ecbea"
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
