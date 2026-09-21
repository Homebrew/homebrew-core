class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "https://www.epicsol.org/"
  url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-3.0.3.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-3.0.3.tar.xz"
  sha256 "63a411215c14040b65b5d728aff10f7523d55e170f6298fb01e1cf958d79d326"
  license "BSD-3-Clause"
  head "https://git.epicsol.org/epic5.git", branch: "master"

  livecheck do
    url "https://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/"
    regex(/href=.*?epic5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "b412bc952a0c67c7751b329ea7d40fc768e3289605a8ac537e65ca55adc7f9a8"
    sha256 arm64_tahoe:       "329dc5c35a410f8d424cf3467191892796138f37fc5325c1e9ca78feda89ac4e"
    sha256 arm64_sequoia:     "0837901c79d2a676d7f226850b1239f6681e0970609ef699b3c97911c325e691"
    sha256 arm64_sonoma:      "bbc2755ded882747be62506d8ccbc35e0b9fb4b4f485bdd531350fcb860c3451"
    sha256 arm64_linux:       "f843392acc228092c2a716b56018c2e5ae34d2db4bf675d9db443bb5eab6056f"
    sha256 x86_64_linux:      "73761cb135d5bb9dbbce04eb52b66398c951fb44b732062d29356e8db6ae2d6c"
  end

  depends_on "openssl@4"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    connection = spawn bin/"epic5", "irc.freenode.net"
    sleep 5
    Process.kill("TERM", connection)
    Process.wait(connection)
  end
end
