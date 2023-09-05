class Libtar < Formula
  desc "C library for manipulating POSIX tar files"
  homepage "https://repo.or.cz/libtar.git"
  url "https://repo.or.cz/libtar.git",
      tag:      "v1.2.20",
      revision: "0907a9034eaf2a57e8e4a9439f793f3f05d446cd"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "5b5d861d3e7a24bfbb41d37e9ab4efe883e9f9403d01b6dc1509480f23f7f80f"
    sha256 cellar: :any,                 arm64_monterey: "02f257866b2d60bc629d5c35f70f41889ab2254de7f29533ab01d600979d74c2"
    sha256 cellar: :any,                 arm64_big_sur:  "7481da1834936b6237f152fe8b7e22196ad5c76833af39c9e9f74eae6347c9a5"
    sha256 cellar: :any,                 ventura:        "d0e2280e4245eda925984747db9ef07b712ccf5e6de713ccc35289e7c6c01c42"
    sha256 cellar: :any,                 monterey:       "de9f3cf843c333e94657378a4b551386f81fe9f3afef5b69539de108330c3c4b"
    sha256 cellar: :any,                 big_sur:        "7424cf8229c7aea825592a76227da3355f32a43b9fbc5e140a0cf1eb07d05c8e"
    sha256 cellar: :any,                 catalina:       "35617f312e3c6fb1e473a5d20a559dcbd1815544bdd99c95419ac7e6e8abf9f6"
    sha256 cellar: :any,                 mojave:         "070d9355e6d03dcb64ea33ecf7e3b99972e0b3ca5fc8e60e89616f0a061ee0e5"
    sha256 cellar: :any,                 high_sierra:    "a263cfaa1499f0c82902009964df0a310e7841ddff29409c67ede0a79157c31e"
    sha256 cellar: :any,                 sierra:         "68bdebde24477a815ea03289878ad57e8a1f719b417bef430bf477c2d760cad7"
    sha256 cellar: :any,                 el_capitan:     "018f1c9897f52b783878db67db39a5933a4863a3f9dedc2af9b6bf13f2161957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5703c44aa7e1572385af551d05f17bafccf9a247eef56639a58dafd5aa8bdd46"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "This is a simple example"
    system "tar", "-cvf", "test.tar", "homebrew.txt"
    rm "homebrew.txt"
    refute_predicate testpath/"homebrew.txt", :exist?
    assert_predicate testpath/"test.tar", :exist?

    system bin/"libtar", "-x", "test.tar"
    assert_predicate testpath/"homebrew.txt", :exist?
  end
end
