class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.8.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.8.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.8.tar.gz"
  sha256 "f7139e7377a2cb059b8b9b14d76a6df5f440e3181cb15ae890d43bbcae574748"
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
    sha256 arm64_ventura:  "33f8063b1091a4ed78261a858a6469addd60fce2fae3bf662d800b695d214bed"
    sha256 arm64_monterey: "daad1aaa7a68c37157ffe1413b7b42a6ccb84861dc364e7ed6f18fb5c42e61c0"
    sha256 arm64_big_sur:  "5bda56800a66fa203e0e4ee496bce2495e86791900c59e34af486a5c0799b6e5"
    sha256 ventura:        "7ae1010fc5a818f9d34f3af95d17d1b199a74ff54ea18a05fdfd852b049032e6"
    sha256 monterey:       "9059bb7d481426b7c40c42203301ddb8db983ef87a6b81c7bd559cbe4d740471"
    sha256 big_sur:        "a5295fda88d783978f9c9eb8b8af88c5ccf606a8e32dbe520fa574fdf2966b78"
    sha256 x86_64_linux:   "f550c15a70adfbcee4149723ccb3ed8d8eb5ceaf78d788ca361116e61e7cfa6a"
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
