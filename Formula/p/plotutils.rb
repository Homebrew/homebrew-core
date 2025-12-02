class Plotutils < Formula
  desc "C/C++ function library for exporting 2-D vector graphics"
  homepage "https://www.gnu.org/software/plotutils/"
  url "https://ftpmirror.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/plotutils/plotutils-2.6.tar.gz"
  sha256 "4f4222820f97ca08c7ea707e4c53e5a3556af4d8f1ab51e0da6ff1627ff433ab"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "d0c2f1bd4307fc85da7079c7e215075d8440c8bb92c44e47d7b449d76afb6055"
    sha256 cellar: :any,                 arm64_sequoia:  "75033cc12b08f20dedc35745e9e85bedd357e49bdeb1f85c18aa3e6c094f7c4a"
    sha256 cellar: :any,                 arm64_sonoma:   "b9cb22e1853063ad3da1d788c15166565b20533ea54484dcca6311839795f6e4"
    sha256 cellar: :any,                 arm64_ventura:  "0f7f764c7ed45dcf462cc30ec41ea6d9439060145bd7b3ee3770c38b8c5adfaf"
    sha256 cellar: :any,                 arm64_monterey: "e20de0661d2b4bed5cd649ac4bc113f652642d539be2cc3a806dc3d991e08ae8"
    sha256 cellar: :any,                 arm64_big_sur:  "df2133fa4e5dd7c50d8145c3960afd6a75e1ff6e5d9e3255ff03cea00ddfdab6"
    sha256 cellar: :any,                 sonoma:         "cf4be8e3f730ac440f962c7b586b5265933121ed6d94c4dc675e9a355b8909ba"
    sha256 cellar: :any,                 ventura:        "5b899b62f779098696d71a54ddba9ed0307110b9f04a21f6a7c11f65d777842a"
    sha256 cellar: :any,                 monterey:       "3ee9b41dfac9fef4f67c7cc09a10cc9ded3337ff31e1bcd3ddab89ab997f82ea"
    sha256 cellar: :any,                 big_sur:        "3ca14b49804af8b7364087731097dc992816d16a82fb6da2afeae18c1772e886"
    sha256 cellar: :any,                 catalina:       "edab5b91771162c1783dc69482834de6a2ca0fd077ea83b79d1934a365f7276d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7f042f52c72e85c663689b220172d739a64e95948fc2c3b6175696c513fca1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b0edefd4bc7eb703cf1579159b7d746502c77538f58b981405c1cf9ba6d042"
  end

  depends_on "libpng"

  on_linux do
    depends_on "libx11"
    depends_on "libxaw"
    depends_on "libxext"
    depends_on "libxt"
  end

  def install
    # Fix usage of libpng to be 1.5 compatible
    inreplace "libplot/z_write.c", "png_ptr->jmpbuf", "png_jmpbuf (png_ptr)"

    # Avoid `-flat_namespace` flag.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    args = %w[
      --disable-silent-rules
      --enable-libplotter
    ]
    # Prevent opportunistic linkage to X11
    args << "--without-x" if OS.mac?
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert pipe_output("#{bin}/graph -T ps", "0.0 0.0\n1.0 0.2\n").start_with?("")
  end
end
