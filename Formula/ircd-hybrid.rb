class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.42/ircd-hybrid-8.2.42.tgz"
  sha256 "692d217bfc7ea37c4e4391fb86b0a92780bc32eb144f69623349721755b81f6a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "268075f11e23a5d819d75d7dd98881c4c0441bbd44fa3ae8b3f799155206073a"
    sha256 arm64_big_sur:  "a6d6a0a26185264577aa3f794fd2a90d215f0a2b63fa84f45b58a74955ca1156"
    sha256 monterey:       "fc209d6f30c7a7ba30a7c856e4893ebe6be74d3c74eecb22e61b87b8606cc58f"
    sha256 big_sur:        "e0de415a58502410f642497c3d857b0f9ccff5400457de66a07214836daf0229"
    sha256 catalina:       "59a906eb2f528eb84ccbc18193ddfab0c47dedd3ca94f4c2b73cdaaa7d4453bb"
    sha256 x86_64_linux:   "5c45e00bfae1c00c4909144592b46ce21755d20eb7287f179b69d0147b159ed5"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  conflicts_with "expect", because: "both install an `mkpasswd` binary"
  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats
    <<~EOS
      You'll more than likely need to edit the default settings in the config file:
        #{etc}/ircd.conf
    EOS
  end

  service do
    run opt_bin/"ircd"
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{bin}/ircd", "-version"
  end
end
