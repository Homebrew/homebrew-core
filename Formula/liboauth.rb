class Liboauth < Formula
  desc "C library for the OAuth Core RFC 5849 standard"
  homepage "https://liboauth.sourceforge.io"
  url "https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz"
  sha256 "0df60157b052f0e774ade8a8bac59d6e8d4b464058cc55f9208d72e41156811f"
  revision 2

  bottle do
    cellar :any
    sha256 "95d253a499d31bbc3ac302b0db62b75e44e60b81130b23cb9f6e94137e350e46" => :mojave
    sha256 "778234aaa005aaf4435350940abee8aa81b1f9de6d0f9db598ec079aafe84b5d" => :high_sierra
    sha256 "d16d94c3bdfe410079ed97872e5d6cd091896c3c8bd9f50ab3244ec5ecb53adb" => :sierra
    sha256 "c6a6cfbc03d34685e1f8ac391980751726e480ba1429105e0456096f66322ac3" => :el_capitan
    sha256 "3d5b00cf3fc8ed4032b1e5e618ab0bfbc962414373ac9bf45a5ee883a4277a07" => :yosemite
    sha256 "9bbd1a6e6cb7c089f3971858b84674545f4125e088072399bace245c29562f03" => :mavericks
  end

  depends_on "openssl@1.1"

  # Patch for compatibility with OpenSSL 1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/master/net/liboauth/files/patch-src_hash.c"
    sha256 "a7b0295dab65b5fb8a5d2a9bbc3d7596b1b58b419bd101cdb14f79aa5cc78aea"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make", "install"
  end
end
