class Libresample < Formula
  desc "Audio resampling C library"
  homepage "https://ccrma.stanford.edu/~jos/resample/Available_Software.html"
  url "https://deb.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz"
  sha256 "20222a84e3b4246c36b8a0b74834bb5674026ffdb8b9093a76aaf01560ad4815"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/libr/libresample/"
    regex(/href=.*?libresample[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "068cbb861da9420760739f884f5d0da524f8d6dd8fbb3496771038f11beb3e2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "79e7e1ab8736164c5c9c6ceb299995ec9771f0cbc3be4d692799595a5ae844bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f8fad6a20232a3f3bd9e1ee90d9242c283c325d2c118ca6b051eb79ab5adbea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9232e1b1d90ad2bb9f8801092358ef64a1a4297196c927dc521ce62229d47d13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0ec7fbf2140acc1295c7397d2e6bb0722c21103941108045f35addd6440fdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2b808178af8d3b7ceccc4c3323ebcf76ad0d3a152c31cbe85c68563cca80bbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c053b159be9058f2f7cd56aff77573414b579b175d2bf2b6421360d568bd789"
    sha256 cellar: :any_skip_relocation, ventura:        "df14982c36aa5c3ceba5649577008bb74b08f33854c0f1428f3b8c9d1290dfa8"
    sha256 cellar: :any_skip_relocation, monterey:       "e02f4a234566b65aee658630f4ff47f89b2a6fb9ec80bca40a9959288060b6b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "623df9f095f427ee794211cd657ad1d1ff5e89f383aa304c9c94d7a27cac36a3"
    sha256 cellar: :any_skip_relocation, catalina:       "779b21b26d28a7318e67e0444b74ee5782715b523c1f79ba9bdff41c334cd312"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "07dabf0e5ac418d11d1cb1e20326ac69e20a199c620e6768c4411a7db878a2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c42f2a35518f75cc11ee79cdfd8985def6d079a7afd8b2b02f74ac82a165122"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install "libresample.a"
    include.install "include/libresample.h"
  end
end
