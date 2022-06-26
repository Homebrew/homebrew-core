class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/v1.3.7d.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.7d.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.7d.tar.gz"
  version "1.3.7d"
  sha256 "b231536e2978116801d06278e805b18e5240568d2bc921693ac7147652e267e4"
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
    sha256 arm64_monterey: "8d97c057ebfbd1ab98b71246881ba2d1222bd1bc84af7eb81ce2bb02e36cf4c5"
    sha256 arm64_big_sur:  "5f881c036c3fc61f8a61e9e8a0b681a9484cda34d6346e8c612ebbd30b687e95"
    sha256 monterey:       "4e204f7b1696bc8271e570bb44bce932cc24a7b09a3ba527bad687222afb8aa0"
    sha256 big_sur:        "2ae3fa57bcdebd8472888b2f49179ec1c43e5ca516021eb3b715e3c2ea75c06b"
    sha256 catalina:       "95239aa03a189cff108522fee0ef1c281547aa662d3f69af74d1dd7416012284"
    sha256 x86_64_linux:   "b4c6e6de0169554fad7d91e497a3c6f4764ad01ebaa31c7ce2771edf0205db2b"
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
