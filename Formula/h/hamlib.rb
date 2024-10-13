class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.5.5/hamlib-4.5.5.tar.gz"
  sha256 "601c89f32ed225e9527ade3d64d0d05d23202c05ae21ffa77e59d70ee4597fcd"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8406c21b77dcaec4da05c92bcd6427e71cd7b3d287857b52d9f1bb7586292ec4"
    sha256 cellar: :any,                 arm64_sonoma:   "458b25ee925c1e679efe780813e20c1a7477fdf86ac0cdcb77d7921e2301ec3f"
    sha256 cellar: :any,                 arm64_ventura:  "273a45da72d9e209e76bd20c4b699207f6fea5b6483dfa2f3a6f5837ed596ce9"
    sha256 cellar: :any,                 arm64_monterey: "2d2952caeac114ef9bb6794cd7e609fcd275508eef0cb6e536802a4741b74145"
    sha256 cellar: :any,                 arm64_big_sur:  "edcf3ece2ef4287a106e149b543b2e0202a1adf742710c266b786f9c94a04c35"
    sha256 cellar: :any,                 sonoma:         "499883bebb250ea72f9ea473033168355e80f0871ca265367e1bc6a1cc951bcd"
    sha256 cellar: :any,                 ventura:        "877fdfa294a99eb9c676409bbb258d86fe02930620c9fc0cbf7de4f46adb6a6f"
    sha256 cellar: :any,                 monterey:       "8c00d183265b56c8569344db90d6fdd54f0008c2012b372f9b4935081de47f94"
    sha256 cellar: :any,                 big_sur:        "fd714ee0ad06f5d07f0a8eaabf0d4284033b86a12847936db320e2f2e4a2be93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6edfd57243916568cf5cbf5e0e6c755a8a4c0dafd5fbb5237374091500f99418"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end
