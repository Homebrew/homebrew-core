class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/refs/tags/v1.48.2.tar.gz"
  sha256 "14f6a25e214e59244fe2b5f0101b78fe9062e83f7ae3cd521c6f0f8f48481b59"
  license :cannot_represent # Described as 'BSD with advertising' here: https://src.fedoraproject.org/rpms/ngrep/blob/rawhide/f/ngrep.spec#_8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e81a2588d449893347f0e960d8b708b327ac39af76bd095be8130c7b8c31d9e"
    sha256 cellar: :any,                 arm64_sequoia: "6cfcc81f373821110c17d05284816c91a7e734cc805872b3b25d28f38ed722e5"
    sha256 cellar: :any,                 arm64_sonoma:  "5d107060ebfcbead5b51101b608c4e0b33e0c363a75551318fee665cfa6dde44"
    sha256 cellar: :any,                 sonoma:        "87a73b0a34c3739ebc113f7bf6407f66a8f5c9b88445db64b48236b8d28f02d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1b5500a4d7c40ffb21e5af7e613b2a72df6ac74dbe0c62c321c6a201293942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97082961593596b60dd944968bee7a23c53bd2a67e0b6994dc2ca6fd744fe936"
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
