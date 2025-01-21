class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.45/ircd-hybrid-8.2.45.tgz"
  sha256 "951ae032ab04a87b47e602339e07e0d06b6e87bd5a4eb334f3b395be14f75e44"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "ad947c9098ff51224cf64839f4cb44eac442696d49377a311322b9e5feeca7da"
    sha256 arm64_sonoma:   "3300892aed735776d3f13175baa889f5d7c9d483d7748418c0909f8415531e97"
    sha256 arm64_ventura:  "23adcd2ed7ea0ec6f2d1697bd9a3387320056d9675da6c7674fadf91a543e8c7"
    sha256 arm64_monterey: "88fb3d88a5c22db625840ab9c5e0b56602249c398a66a5ec588b384dab3f8dc9"
    sha256 sonoma:         "6a7ff02a200163d69f6db115ff5b4ac256d9f0f0d206f209496f209bd34a5a5b"
    sha256 ventura:        "b671e85eb7f66efdd2b797dc67d026d29330f0b9911e246766f7e96108bc2cd5"
    sha256 monterey:       "032ceb7c545a5fceda538205a747e231505b899c7a3ba81099a59ad08d69ea38"
    sha256 x86_64_linux:   "d972f1b694aa724347492b9c39a747d63bd46f202f9e86b7fb086fc5bba3f284"
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
