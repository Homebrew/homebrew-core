class Nfcutils < Formula
  desc "Near Field Communication (NFC) tools under POSIX systems"
  homepage "https://github.com/nfc-tools/nfcutils"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/nfc-tools/nfcutils-0.3.2.tar.gz"
  sha256 "dea258774bd08c8b7ff65e9bed2a449b24ed8736326b1bb83610248e697c7f1b"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d5e8601208972b4d6fbd0f0283072529eae6a61edb01a031ee6ce18c2bc15e17"
    sha256 cellar: :any,                 arm64_sequoia: "3140444a44dcf96b0cbf034ca29ee04288bcf13e386ad2bacc7692f69c24a075"
    sha256 cellar: :any,                 arm64_sonoma:  "10686937692e08cb276c59997a90c22b62651fcebbe597b258d91ce49a712feb"
    sha256 cellar: :any,                 sonoma:        "5d8bbe778c1def520d20b9a9d7295d018edb76e7636aa253c9d892032832bed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9149c273b20175985316aa9fee6c7bbbac089f40ce25b3be1bbc817a82f692ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d472ccf250a3286378ade84f417372011bd33c966076b397e2b3351c0f86f4"
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
end
