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
    sha256 arm64_tahoe:   "ced31af7ab40d6fae78409d8b4a4ef407900e08c8ffd795181ff9feb0f666b21"
    sha256 arm64_sequoia: "743e4ab0d73cc1f2bdf1e001208f591769669d571e5574d176b9fe30ee560861"
    sha256 arm64_sonoma:  "d89d9c3332a770fbf037185fc5ca51445be55f6688026bd206b85abe193841ca"
    sha256 arm64_ventura: "af11032c6a1f98e4d0c7c47c8047e3abd3a97c3ce2176078a1827f51b36cce9c"
    sha256 sonoma:        "68900262656a9b8985e91cd6e52008fce99e3b673f2aeeeba66f6662b04462d2"
    sha256 ventura:       "cb7ee4cbade3c44adffae316dde30b1787be74679337822aeadea60500da6f3e"
    sha256 arm64_linux:   "ea6c9c4afda6a1ae077111114b3a13ba83dd2168dcad1cb148862c3bd9398d27"
    sha256 x86_64_linux:  "6562f2e4c0c28c6127a5dce9dd311bc655c6abc6e3f14707d8837b840c8e3b56"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
