class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://github.com/nfc-tools/mfcuk"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfcuk/mfcuk-0.3.8.tar.gz"
  sha256 "977595765b4b46e4f47817e9500703aaf5c1bcad39cb02661f862f9d83f13a55"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "be0033adbb689b747a0674ed97a84822a1ca5c146d41572e32e684c541f3ea35"
    sha256 cellar: :any,                 arm64_sequoia: "22ae94383bb98fc83419782d77d1d60532a48edcba1ab27a2ae70f62e48d3d82"
    sha256 cellar: :any,                 arm64_sonoma:  "f3e02474d0f40ec5d9a6637e44d4a7bea72f52ae070c66e29efdf00430f7a009"
    sha256 cellar: :any,                 sonoma:        "a7f0de18fc9d0c008d607c9f9886b764e5700d0a62b8005c88e3a7407fbb54a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32722adf6a0c314f40820e8fe269fd908c8d2b76520375b65de4429cb678a214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20226cc243757f600009e6e293932a5ece56ba4bfeb0e51d6931e554020be069"
  end

  depends_on "pkgconf" => :build
  depends_on "libnfc"
  depends_on "libusb"

  on_macos do
    depends_on "libusb-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfcuk", "-h"
  end
end
