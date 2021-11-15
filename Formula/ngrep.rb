class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/V1_47.tar.gz"
  sha256 "dc4dbe20991cc36bac5e97e99475e2a1522fd88c59ee2e08f813432c04c5fff3"
  license :cannot_represent # Described as 'BSD with advertising' here: https://src.fedoraproject.org/rpms/ngrep/blob/rawhide/f/ngrep.spec#_8

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9539b7c9783bce244c1310c691766b6c14fbc9a1c0b00ed9b480ed41575717d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bc88f61eaba46026963de70f44e84f73f04b041e913051fb21f3351d16cd9e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b7f33fabe9f42533580c021d441d4ef8132150c345add38cf9fc6452efa611a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ab0d459dad3462b127af805de369dac2f099844126d70e89e531ea181d0e794"
    sha256 cellar: :any_skip_relocation, catalina:       "53bf6d68b15a2f07a01d828cdcd137131a45871141da411328c376ed90768265"
    sha256 cellar: :any_skip_relocation, mojave:         "0d1948b2fbf7c60fb6e46f15d32a51a3f7754e7372924e4e984cce98282ca281"
    sha256 cellar: :any_skip_relocation, high_sierra:    "390424274552105e21b3f3e926b933322a09333cee02274d2f84a5e23f4ea74d"
    sha256 cellar: :any_skip_relocation, sierra:         "0e915d1e3b7e7da8e58a48457de4e40359cb0f870eb45a77302d36c1b767d044"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d057c167d3b695ff915c13fd39e3cd7b3e6e2a5b3f82bce6bb8ea4c030e8f6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54a418af69d95d16a04604e385faa40791e6ae6bc488a7f146b0f22a2845a5b"
  end

  uses_from_macos "libpcap"

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""

    args = [
      "--enable-ipv6",
      "--prefix=#{prefix}",
      # this line required to avoid segfaults
      # see https://github.com/jpr5/ngrep/commit/e29fc29
      # https://github.com/Homebrew/homebrew/issues/27171
      "--disable-pcap-restart",
    ]

    args << if OS.mac?
      # this line required to make configure succeed
      "--with-pcap-includes=#{sdk}/usr/include/pcap"
    else
      # this line required to make configure succeed
      "--with-pcap-includes=#{Formula["libpcap"].opt_include}/pcap"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngrep -V")
  end
end
