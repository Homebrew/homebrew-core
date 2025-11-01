class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/refs/tags/v1.48.1.tar.gz"
  sha256 "9b5d6d9742fd9818ac88291784f6a3250cdfe953736c449baebf188300c582b8"
  license :cannot_represent # Described as 'BSD with advertising' here: https://src.fedoraproject.org/rpms/ngrep/blob/rawhide/f/ngrep.spec#_8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e6eaba4477e7a4b71e82c79e79a75e332b1a487b9fac32b66d6d02716d13bca"
    sha256 cellar: :any,                 arm64_sequoia: "c8112d09a7a11467016d8e24bc415a7d9e9e5a53e5fb140b248ac483bb0c1809"
    sha256 cellar: :any,                 arm64_sonoma:  "fb46a7d9f3501bf1960204e524f2aacd6f8b43fb2c9700f7afeb3d0ba8910123"
    sha256 cellar: :any,                 sonoma:        "78acc794ff77f9a5de5fcba6a74fdff5d548b94c4c3029644a9c31c195b518fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3999f9c875dde9ccc1f43f0c110fba879c7c2f140b51cab4e1765f3a4042e328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c3ae98eab72985d04c368437233fe8e12573a88c9248c73503f6984f3b4738"
  end

  depends_on "libpcap"
  depends_on "pcre2"

  def install
    args = [
      "--enable-ipv6",
      "--enable-pcre2",
      "--prefix=#{prefix}",
    ]

    args << "--with-pcap-includes=#{Formula["libpcap"].opt_include}"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngrep -V")
  end
end
