class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "https://github.com/proftpd/proftpd/archive/refs/tags/v1.3.8b.tar.gz"
  mirror "https://fossies.org/linux/misc/proftpd-1.3.8b.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/proftpd/proftpd-1.3.8b.tar.gz"
  version "1.3.8b"
  sha256 "183ab7c6107de271a2959ff268f55c9b6c76b2cf0029e6584fccc019686601e0"
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
    sha256 arm64_sequoia:  "7d223f2cd178e9a815cd477caf3a34f924564303c9fe10cb638ca6ae725646fe"
    sha256 arm64_sonoma:   "48a583547c7df3b834deccb641a235f8b0d562e0e2f27bc978b04dd3540a46ca"
    sha256 arm64_ventura:  "a421f924d2ad5a50c4f5c05702449b09fa7c0f59a61eb61189bc43ba4f7b0625"
    sha256 arm64_monterey: "759316ccf7c904a7d275df4b4729fd2f70c74f321352669c7e44a4ea4bd3870a"
    sha256 sonoma:         "3093cf6430a010f08e2d9d0b532fe748af26894f2e89b48824e9b21a028a58ea"
    sha256 ventura:        "b8c0a627557359dc1e034a717a37b788bf1d020b98a48501a6b047ed9eb0dd35"
    sha256 monterey:       "29bbea5b246e883d1e9ff9cb2f799d6a85d1e8eb0325d64c88795a70f2c57f9b"
    sha256 x86_64_linux:   "a979d3cf427cd3e56eaf0c71a110d7bb5ff5517d97d60ccabfd7bc8be25c7af2"
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
