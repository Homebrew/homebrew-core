class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage "https://www.eyrie.org/~eagle/software/kstart/"
  url "https://archives.eyrie.org/software/kerberos/kstart-4.3.tar.xz"
  sha256 "7a3388ae79927c6698dc1bf20b29717e6bc34f692e00f12b3369d896f6702060"

  livecheck do
    url :homepage
    regex(/href=.*?kstart[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d61ac55725238820aefe15b3fb7e939f9876bad579a79115168aa60b85a6a9dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "c04cfae543a35bca681ab197199b9ff322e0e93952a89977d4a1f18d1a66d473"
    sha256 cellar: :any_skip_relocation, catalina:      "2f12abc9ac0bdbfca86072d55b28e475be772f9fe910082ef3050212565ec17f"
    sha256 cellar: :any_skip_relocation, mojave:        "6c78dc7caaf8986ecf39687e5aee453aa451f885a9e1b39416a1f294a0aba12f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1e587dc42a73f770ae6a6793de1fbc46a540fbbdf0935be7505b8da8646965d6"
    sha256 cellar: :any_skip_relocation, sierra:        "271ec8468ad4aa1e46dbe4674f9e214d563fc2ea689279e860b4b8324d2196d8"
    sha256 cellar: :any_skip_relocation, el_capitan:    "493a3dcca4b6b50ba44687c8b4d78cebf044a9c6ab465eb344aa3d29c64a39fc"
    sha256 cellar: :any_skip_relocation, yosemite:      "c90ef2d0808350085d616f7cfae6001b47e04ec3d2ced85bd0f7427abba6ff6f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/k5start", "-h"
  end
end
