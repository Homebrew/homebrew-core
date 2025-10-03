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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "733a179f707e522c3b44c603a5fddfc616d22a4c94dc0a721f76f000c3499a66"
    sha256 cellar: :any,                 arm64_sequoia:  "4bf7e151ffff1de41f8ce86bab303b7afb6e40b0f5417fdfada6a73fe633b6d6"
    sha256 cellar: :any,                 arm64_sonoma:   "8e4dc030caca81ca64460297f68f5f4d03d51a9836b4e9b7da4b30c63a9f3d89"
    sha256 cellar: :any,                 arm64_ventura:  "c3b2dedf19a1253a4e9b5eef4ae278875eda2759f82c8ec9d503ead44ce0fcd2"
    sha256 cellar: :any,                 arm64_monterey: "d2eae4352ba72db26b2b38798cfb1c48f937df4e4cad3a5d50036abe2a2b8f52"
    sha256 cellar: :any,                 arm64_big_sur:  "659dd378a4d6fc0f96d3752b6fd8303f0f6c79beeb0424fa8456ec33d270fb02"
    sha256 cellar: :any,                 sonoma:         "ae1f9e5a3adda8bd22e705739a3dd2f76fc1eb2aeb7accf21e0fdfad5164a378"
    sha256 cellar: :any,                 ventura:        "f8cad830872535b888d97d61e4444b5dc16091afbf340f358a2c93e6d464ce86"
    sha256 cellar: :any,                 monterey:       "cc0e8ee52305c15554adcf6e50c52ea670ac814001092d82b45f7083e9399928"
    sha256 cellar: :any,                 big_sur:        "09ee4e144cb7484994278cf3698474f9d205fb38d926c1936046c422eb772a99"
    sha256 cellar: :any,                 catalina:       "5f9cd0c17ee17754bfe88c6e275111270e0a0d0cdebb663a0045d6ad49c8b9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fcc897c306d8db37b369010254a87762845eefd5aad185938639b0728250af53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e160d02015fdfd48ef348ef8f73bb6040e2a66ff9047cf1bc7f720ad94c173a7"
  end

  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "libsndfile"
  depends_on "pulseaudio"

  def install
    system "./configure", "--without-alsa", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"minimodem", "--benchmarks"
  end
end
