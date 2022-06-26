class Cvsutils < Formula
  desc "CVS utilities for use in working directories"
  homepage "https://www.red-bean.com/cvsutils/"
  url "https://www.red-bean.com/cvsutils/releases/cvsutils-0.2.6.tar.gz"
  sha256 "174bb632c4ed812a57225a73ecab5293fcbab0368c454d113bf3c039722695bb"
  license "GPL-2.0"

  livecheck do
    url "https://www.red-bean.com/cvsutils/releases/"
    regex(/href=.*?cvsutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2a9644fe70816d7ca61c0497ce3baad7a81596e69254cf9d7d775d9e430f7f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7173229e45bd423c11d21800ddf636afdb0903fff09e0514b21a3065ce8fba3"
    sha256 cellar: :any_skip_relocation, catalina:      "f8637db7bc660a9953b96bca2e68d1ba7c56bd0766e0ef12bc6b0b42d972ae3a"
    sha256 cellar: :any_skip_relocation, mojave:        "e497ac1ba036fec1ccd8d34b2ec6262f9721ab805d0636f073c5406ef4fbd922"
    sha256 cellar: :any_skip_relocation, high_sierra:   "102456ac28b63271b03a5722e8421d6273005c54203f4f818678be065479463b"
    sha256 cellar: :any_skip_relocation, sierra:        "d1f2e13e0df6dbb767a04f7e206114c119f9e6435f227e07e14b4d200e6aba8f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "f8e35c8b0ed2db868e7dd12f653c20d7d2709059fb5a773fd49084a2655f4ca0"
    sha256 cellar: :any_skip_relocation, yosemite:      "ccefce4b4a1053e9a32e4f43318c7bf73c7154f0bee1be1cf1777e8fd3e8eabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc4162b5c2691b48d6a65ad467eb32c3139787c1de0d42439063b1f3cd6f57f"
    sha256 cellar: :any_skip_relocation, all:           "aeccad5743770ecfbb4c92fcbc9899927714b1214fa89dcdba6d4fa6ae630f2a"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cvsu", "--help"
  end
end
