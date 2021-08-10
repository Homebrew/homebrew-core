class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.38/ircd-hybrid-8.2.38.tgz"
  sha256 "c51034873a30823490b5bdfb3e7c3b75ed673ed947020d85c1131268a76bfb63"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "4ebf1dabded38700beebe68996227c61364de7ccb5eacab75a281cac42d89cf9"
    sha256 big_sur:       "667f3e98bde41933f4a672cdc7f8ab58d9a4cb554939a758fad897f7a594f530"
    sha256 catalina:      "8475bfdc42a50e23ba0c0a0f00b7c4fde1a5e6b94eaa88a32c139184401b2bb7"
    sha256 mojave:        "73a186cbab7d289e501c600eb633c56ab1bae6aff1a20e98878b258436174220"
    sha256 x86_64_linux:  "dbfd3374ad89b1fdf994da5a70a3e73d2be7a6084231247bb697eca40a5a8a2e"
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
