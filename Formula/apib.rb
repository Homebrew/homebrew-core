class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_0.tar.gz"
  sha256 "1592e55c01f2f9bc8085b39f09c49cd7b786b6fb6d02441ca665eef262e7b87e"
  revision 2
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha256 "6ebf28013ff33494c45a67b4e66abf15549a90cac60fc8bb0f8720ebf1387623" => :mojave
    sha256 "3ceaeadbdbd7c70211b7774ab76cff8e4d5176d4f04e4f1984043ec16002c4ec" => :high_sierra
    sha256 "f0443f15ef97284cefe199c11f7cbb14d6b41e48c5d13d6a372e9d47c1410573" => :sierra
    sha256 "cc30447ff51239eb2334d85b2f3faf0842b21ff882d8a4edb2e99155cb1dab76" => :el_capitan
    sha256 "9cd200dbdb251c5d50e7fa2307a6252aa295a4a7ac0e594d0774ad1d2631215c" => :yosemite
    sha256 "b14202356551d0b33446c99d38c4ed0f1d4893aa8e203fd04b6923db18ff40c1" => :mavericks
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@1.1"

  def install
    # Upstream hardcodes finding apr in /usr/include. When CLT is not present
    # we need to fix this so our apr requirement works.
    # https://github.com/apigee/apib/issues/11
    unless MacOS::CLT.installed?
      inreplace "configure" do |s|
        s.gsub! "/usr/include/apr-1.0", "#{Formula["apr"].opt_libexec}/include/apr-1"
        s.gsub! "/usr/include/apr-1", "#{Formula["apr"].opt_libexec}/include/apr-1"
      end
      ENV.append "LDFLAGS", "-L#{Formula["apr-util"].opt_libexec}/lib"
      ENV.append "LDFLAGS", "-L#{Formula["apr"].opt_libexec}/lib"
      ENV.append "CFLAGS", "-I#{Formula["apr"].opt_libexec}/include/apr-1"
      ENV.append "CFLAGS", "-I#{Formula["apr-util"].opt_libexec}/include/apr-1"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "apib", "apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
