class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.41/ircd-hybrid-8.2.41.tgz"
  sha256 "ce0ea69654601047bd86423ddc0023c0795570249990011eaa6c41d6372b0454"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "0f6c13a829545e5a796acba88ad42678dd2f4908a965bf5cf89619455a8ae6b4"
    sha256 arm64_big_sur:  "c8adfa269bbfe8f34d94a2542dc9680e21cb42a2bbbb01e9b8477deee29ba60f"
    sha256 monterey:       "81cb7493f3bd8bded4c0bbbb64d57feba05945a0de83379c8204bd7e3d7a1f02"
    sha256 big_sur:        "6b459c58b58c78f890cf0353d5e39b2d00db17ff26c2f399f46533e8ab01e80a"
    sha256 catalina:       "af39380538d12d8956ac1cf349698c0c19fa6b24d45f1155a70eac6b7c12a1c2"
    sha256 x86_64_linux:   "6fcde9901e6be907170d00bce83f718739ba871b6a901d2b505b814a0a6c8722"
  end

  depends_on "openssl@1.1"

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
                          "--enable-openssl=#{Formula["openssl@1.1"].opt_prefix}"
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
