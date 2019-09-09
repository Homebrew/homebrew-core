class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.0.tar.gz"
  sha256 "5a60e0a4b3e0b4d655317b2f12a810211c50242138322b16e7e01c6fbb89d92f"

  bottle do
    cellar :any
    sha256 "372930dce3e97d7ff42ceb60c21996b98bc05eeab16c4badf7d224ae9c3bc3b2" => :mojave
    sha256 "77be2ee5af3ae642658118eac2fad889b48995fcfb183ff0602462467ba0cb22" => :high_sierra
    sha256 "a430c3f1cdb8e9be02aa18c89483309431e77ae4daf3b8288e1680fe60e129c8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
