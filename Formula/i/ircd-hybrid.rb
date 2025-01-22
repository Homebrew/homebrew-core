class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.46/ircd-hybrid-8.2.46.tgz"
  sha256 "a5d5c8f1888fa82fbded7a313456f5a659b871f2ce07e6ff81eb5a8d73f3c74b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "482a6473c6ba13884a37432848afbebcdc3942a5528fdcfe79740d0b9968e4ae"
    sha256 arm64_sonoma:  "2f170975dbcadbbdfdadcc779760c14657d3248d1f098c238f6111293e79bf92"
    sha256 arm64_ventura: "1d31e662ad08d3399c13de2de890351b7450e448bb7dd5f9dcc2e4c040c6d77f"
    sha256 sonoma:        "613595b0cafc86ee1cd5d2622b4370a9b8718dd052ee6dd363e7698bdd5f0670"
    sha256 ventura:       "2148dfdd86ba6c791a0fc1e49fbe918c2a1e4874fe4bd58774fd6a8b2e56dc52"
    sha256 x86_64_linux:  "031299ee9f3e08184069491b048f1005e5c73b098247a0d33765c95fbae7a438"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  conflicts_with "expect", because: "both install an `mkpasswd` binary"
  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--with-tls=openssl",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
    etc.install "doc/reference.modules.conf" => "ircd.conf"
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
    system bin/"ircd", "-version"
  end
end
