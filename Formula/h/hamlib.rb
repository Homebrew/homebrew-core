class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.7.1/hamlib-4.7.1.tar.gz"
  sha256 "d197a08a3d5d936d7571ae573f745bbba619e88998742c8267e3fcb0fb3d5974"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a15d17d84db87b76f1cefff6599cddd5987e4a1bd06a62c24934db82d1afaecd"
    sha256 cellar: :any,                 arm64_sequoia: "5602a7cceeb1f70927ff9bd8f9789801ca99e20839927be69af1d69f11df8169"
    sha256 cellar: :any,                 arm64_sonoma:  "5d5ef6222b66202c64fd5f3920006248a6bac227af541348aa271a0b4002e259"
    sha256 cellar: :any,                 sonoma:        "e0a06769fb90de54e742255eeadf6f2ca102a77ff8fe253eeafbee677e92c09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb6d74a31b9a263f8f5fd15429fd00f163d65ad636391820676383ea6db2d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd85b22bf603d9166733d57e2720be95d1da42f164558de1cfd53474657780f8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end
