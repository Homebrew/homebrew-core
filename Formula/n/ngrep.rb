class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/refs/tags/v1.48.3.tar.gz"
  sha256 "7c69777c21cc491368b2f1fe057d1d44febcf42413a885b59badeade5264a066"
  license :cannot_represent # Described as 'BSD with advertising' here: https://src.fedoraproject.org/rpms/ngrep/blob/rawhide/f/ngrep.spec#_8

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a52f45391fb49ab6a9f03292146fa91b63e8f6b599f7d16f32b5aa2615626242"
    sha256 cellar: :any,                 arm64_sequoia: "f8e867653a689f5c6850a9839e3f7755a6726cee3abfec63f08d97f6522bbf9d"
    sha256 cellar: :any,                 arm64_sonoma:  "eabb2d03d723b9942af2b6e712cabb4390146fb02d4fe3f98f59090136dafd98"
    sha256 cellar: :any,                 sonoma:        "d73d8e8ceb1654283fc8db53677aeb9cb9f0df24845ee39db9bda97a94792615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d58f77a14050e727f52654d0d6e047cbe90eb6998e1cf3e4f1125b8d33116e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbe2f54cbfac61e8fcdf83a4db4dc0acabac1d18927222bbdc46383b0bdecb0"
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
