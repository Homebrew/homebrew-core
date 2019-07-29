class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage "https://www.eyrie.org/~eagle/software/kstart/"
  url "https://archives.eyrie.org/software/kerberos/kstart-4.2.tar.gz"
  sha256 "2698bc1ab2fb36d49cc946b0cb864c56dd3a2f9ef596bfff59592e13d35315cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c78dc7caaf8986ecf39687e5aee453aa451f885a9e1b39416a1f294a0aba12f" => :mojave
    sha256 "1e587dc42a73f770ae6a6793de1fbc46a540fbbdf0935be7505b8da8646965d6" => :high_sierra
    sha256 "271ec8468ad4aa1e46dbe4674f9e214d563fc2ea689279e860b4b8324d2196d8" => :sierra
    sha256 "493a3dcca4b6b50ba44687c8b4d78cebf044a9c6ab465eb344aa3d29c64a39fc" => :el_capitan
    sha256 "c90ef2d0808350085d616f7cfae6001b47e04ec3d2ced85bd0f7427abba6ff6f" => :yosemite
    sha256 "983306746f5c1273ffb86eb4719c01527e4df317fee1c01daf371c6d60e6f8be" => :mavericks
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
