class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.2.0/HandBrake-1.2.0-source.tar.bz2"
  sha256 "113b398a50147d48c8777e6ff2c4de6825af5f1079b3822e41bf0eacec9c940d"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc63f8895c64022adfd8e58fb28870ec8d7185667e27940c2dc45074d1fa1b70" => :mojave
    sha256 "f707a42cd6f6100600a5fa13a4dbb9bc3b666ddfc2f094100121f5427383d708" => :high_sierra
    sha256 "b417f28b91ac621ed30aa08f3bcbbc2de705739239fd8674870e77ae98a10614" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
