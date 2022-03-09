class Minimodem < Formula
  desc "General-purpose software audio FSK modem"
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.24.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/m/minimodem/minimodem_0.24.orig.tar.gz"
  sha256 "f8cca4db8e3f284d67f843054d6bb4d88a3db5e77b26192410e41e9a06f4378e"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?minimodem[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2eae4352ba72db26b2b38798cfb1c48f937df4e4cad3a5d50036abe2a2b8f52"
    sha256 cellar: :any,                 arm64_big_sur:  "659dd378a4d6fc0f96d3752b6fd8303f0f6c79beeb0424fa8456ec33d270fb02"
    sha256 cellar: :any,                 monterey:       "cc0e8ee52305c15554adcf6e50c52ea670ac814001092d82b45f7083e9399928"
    sha256 cellar: :any,                 big_sur:        "09ee4e144cb7484994278cf3698474f9d205fb38d926c1936046c422eb772a99"
    sha256 cellar: :any,                 catalina:       "5f9cd0c17ee17754bfe88c6e275111270e0a0d0cdebb663a0045d6ad49c8b9a8"
    sha256 cellar: :any,                 mojave:         "4c89fe35fbc5478c20d1db50f023c7c89467b7fbd17bd77810a6e8ff63e4b945"
    sha256 cellar: :any,                 high_sierra:    "091170cbfa058de152f2f1af5f2436963297c01e323e80fdfcd5bcf6d8c9cabd"
    sha256 cellar: :any,                 sierra:         "224fc001ea92a1df8133680c6eb9b6d659912d5e8ce84e8c12509a671538d8ae"
    sha256 cellar: :any,                 el_capitan:     "1539133df2fe9f85e8dcdf56e2a62d5ae116861e6dbc3b02e45680fbf8a467a9"
    sha256 cellar: :any,                 yosemite:       "ac39bf2ca304ce0f513a037193aca0850cf3cafddf17cd40a2ac047e5f051db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e160d02015fdfd48ef348ef8f73bb6040e2a66ff9047cf1bc7f720ad94c173a7"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libsndfile"
  depends_on "pulseaudio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-alsa"
    system "make", "install"
  end

  test do
    system "#{bin}/minimodem", "--benchmarks"
  end
end
