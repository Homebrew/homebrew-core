class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.47/ircd-hybrid-8.2.47.tgz"
  sha256 "d5f253f6dd1a93e7183323f410b7e2269ba4392d3d00a0e7dc6248f6f9864ffe"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e9276cb8e64c822896016e2855e398371b2970fbee6b55ade0b0422bd3b07330"
    sha256 arm64_tahoe:       "7a5ae94ff8e74327e53938df7ea6b2a065b413ffc9b97a5e316ecf9974b68d0e"
    sha256 arm64_sequoia:     "17d62791a7e1ef3d9d3093594f222cb78920f407191d716c7fd535215bf659ad"
    sha256 arm64_linux:       "d068f5890944e393f197fa7e4c37fed0b6b39aad24d230f21e07d7649e3d376b"
    sha256 x86_64_linux:      "e987a8450ebeba6c092650c87b6b4dd823aab44ff1ecc74a78f70f8070fd1eb7"
  end

  depends_on "jansson"
  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  conflicts_with "expect", because: "both install an `mkpasswd` binary"
  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  deny_network_access!

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
