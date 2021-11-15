class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.39/ircd-hybrid-8.2.39.tgz"
  sha256 "035d271f6b0dd451157f80146d189bc1c9b84cc9ba1b7ad06fd72ee5108e6e4d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "3a92eb47b04dddeb6b626f232d859c6cfb1828c331438b1ccaedb99ff92c494e"
    sha256 arm64_big_sur:  "b31fc7ba489af06e2decf331466810c4477774e3c7af42fcbba77882e535c97a"
    sha256 monterey:       "429c423e85d054b705c31c68d98f32259820f9893ee1b5975d1e47d2fc2552bf"
    sha256 big_sur:        "c0b51453c0d7c82c6fe504fcb3d7de3aaf181774621ecdfb1a298bc21bebe6ee"
    sha256 catalina:       "c918bce271461b22e1eb2632db3c55ea82ba8b3e3822b1acf6e0dc09a804cda4"
    sha256 mojave:         "53db2d5110d8a486bbb7ed75858f5920838abc4c263e8e732814a87d0015575a"
    sha256 x86_64_linux:   "fc31f26e809d59c021617055aa26a5f318ba101ce8311c18afbb08233c959627"
  end

  depends_on "openssl@1.1"

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
