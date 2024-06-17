class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.44/ircd-hybrid-8.2.44.tgz"
  sha256 "6bf0c2ff5fc643dc1757a232c9bd5825d33891c7cc1837f024ad4fff7c61c679"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "72fdc6acf53edb6e1d9eb992b62f4b0a40d8179ec3d6901431cb5686292cf4a3"
    sha256 arm64_ventura:  "9daae1aa570e53ed800fbea6bcd728b315a56b6b63e83db3e8a4b530f7990f42"
    sha256 arm64_monterey: "dd47cd78b1d73d65cdc39009d11a7acbc1bc7798d5df698bbf5aee1f170f1cd0"
    sha256 sonoma:         "542ea12fe02e1112a863332c2a091a2cdcfcd2ed1bcf86c863649285a5e28597"
    sha256 ventura:        "f045df6dd88c979d70c4b4e9f9181492e5ee420fd086b39a56d8f0061f16c3f9"
    sha256 monterey:       "b5988373fb4c8596bdfdf13ac57a8df69077e2fd65cd60e04076556c53649898"
    sha256 x86_64_linux:   "40e86951cf10d46446468540e2142b894bc03608e8e47aafdd166cf397fa85fe"
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
