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
    sha256 arm64_tahoe:   "572871b3f42957d9c287fcc6322112cb27169087b07522d802880d54ab8b83ba"
    sha256 arm64_sequoia: "c61a232e6b16f0e0df0382399bdaa612ccd755e20611e356b6687745e64da69c"
    sha256 arm64_sonoma:  "602e3329ab2c61db98749f3e4ad0237db35542c7284034e0dc36ff3606c9544c"
    sha256 arm64_ventura: "143e5f32b944813a8d5891665000739043e1e537a1d0c6a9b8e28b3c63893f4c"
    sha256 sonoma:        "bc9a3ce5fe871c70917f827f5a56631e71b4852609e9372f8eedb493752a8de2"
    sha256 ventura:       "c1a7944fb9568fdec12b8daabad9d75d50844f9e4e535ce8bd8dfe8347e1b28a"
    sha256 arm64_linux:   "f4b2f1f47eea9e04695a498e5031229a828305107530b8811422d772542b9cd3"
    sha256 x86_64_linux:  "5026f20ed6cb34c59dddb2e7df8f9388cb9e148c55d8c4d7fba9668ea140bb11"
  end

  depends_on "jansson"
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
