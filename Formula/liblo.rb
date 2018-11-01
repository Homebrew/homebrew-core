class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.29/liblo-0.29.tar.gz"
  sha256 "ace1b4e234091425c150261d1ca7070cece48ee3c228a5612d048116d864c06a"
  revision 1

  bottle do
    cellar :any
    sha256 "47694db74756045244bdd32db28174e143f3cc0812809d340fafa862c7f8b540" => :mojave
    sha256 "961d1559e59bdcf92134a61c799456db776434d4309c2b1dc0ba17581fca7084" => :high_sierra
    sha256 "a618d8405b4e13bc1871a5a24da2489a2b64f3d08bff3b7920bf8a6b2b3d6302" => :sierra
    sha256 "4d5fb18d769550dd5415441b78e167533813c36391819f3c67ea7ea1e69ce7a2" => :el_capitan
    sha256 "2e2a5f7bc6e95657cec57fc1b969c32dac1405a9731dffec1983c69cb941dde2" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
