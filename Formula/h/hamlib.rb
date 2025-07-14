class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.6.3/hamlib-4.6.3.tar.gz"
  sha256 "aefd1b1e53a8548870a266ae362044ad3ff43008d10f1050c965cf99ac5a9630"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ffbbba247c2c2285f2b19e9fda50646bbdd45476a293c4e908963d4614676ee"
    sha256 cellar: :any,                 arm64_sonoma:  "4f51a751b7b483c5ffebdcdf05d3bb8714cac40c651951d64bd0fdfbe3f79cc6"
    sha256 cellar: :any,                 arm64_ventura: "26d39780b1b3ce9cc073bf395df38e65af1a7d163547c20322ab4347ed7c3969"
    sha256 cellar: :any,                 sonoma:        "56a9e21da503a34caf05686e2eeda246db01b6475dbbe55f40c0a3348fe22714"
    sha256 cellar: :any,                 ventura:       "79579e23604ae313fc22bfba9846d32e4ae56a2d72d93f086877a05d70ad0bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59172cb178808e89786cfd91e82177e89e7dccb54eeadc3048a81f7f35685c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a5f8de5f9041ba70cc9f11656c4707a8598fce8bbe4aa331df9eef25ac907c"
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
