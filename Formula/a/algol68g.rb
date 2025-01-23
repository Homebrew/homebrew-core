class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.12.tar.gz"
  sha256 "720ab4411d589180a85ba1d4c63c90b5a77e9be1b345e27c25ceb743d88cd71f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "29b60b6c00ab8073800ae3a1e2b9fa73b7431eea389ab5d26d2afd38dc519a57"
    sha256 arm64_sonoma:  "a7b8aae40a085c3e70f688d24d728687316122be10b98c2e262eacec29fa566f"
    sha256 arm64_ventura: "525bc7c5bc3f3859877fbe614ceeeae7a5614b85e07e02949b37a3a148e922ac"
    sha256 sonoma:        "7ad08e6fd00d07deb34811682914fc765c06090e90b361b087840556622b924f"
    sha256 ventura:       "15d027ac847bf71fbc94c4512f36a96c1cde51b974b29149432c35d410b440ed"
    sha256 x86_64_linux:  "34ecdc810a98ca4498f37f23a1635cda9ef1a3a505502730a8e137684c9ce0b1"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
