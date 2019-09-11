class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_0.tar.gz"
  sha256 "1592e55c01f2f9bc8085b39f09c49cd7b786b6fb6d02441ca665eef262e7b87e"
  revision 2
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha256 "c187a92d566f8ab7b92e1bfef485f78236ff84f5d4f9e2fe5692863503b6c246" => :high_sierra
    sha256 "e6fcbc9853b5796b2fe39c2c12aad813d764a3558595d834c2e5862376755d9c" => :sierra
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
