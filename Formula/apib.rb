class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_0.tar.gz"
  sha256 "1592e55c01f2f9bc8085b39f09c49cd7b786b6fb6d02441ca665eef262e7b87e"
  revision 3
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha256 "89a8653925243569be382dc7a7816a836e020973e627ba0a0b3926e3de0ba684" => :catalina
    sha256 "ca59f86634b3b9282496f95b432aa9e0c9924eb189c1ec2965d427edac8bab4e" => :mojave
    sha256 "f2adc68de1b28e305ad7530ec097425bcf75beb70d6dd820f025cabcbeb54585" => :high_sierra
    sha256 "bbe9bc25a8584f163347662675d78b69cdfaac495be5f2fa026dfca112f8d4a4" => :sierra
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@1.1"

  def install
    # Fix detection of libcrypto for OpenSSL 1.1
    inreplace "configure", "CRYPTO_num_locks", "EVP_sha1"

    # Upstream hardcodes finding apr in /usr/include
    # https://github.com/apigee/apib/issues/11
    inreplace "configure" do |s|
      s.gsub! "/usr/include/apr-1.0", "#{Formula["apr"].opt_libexec}/include/apr-1"
      s.gsub! "/usr/include/apr-1", "#{Formula["apr"].opt_libexec}/include/apr-1"
    end
    ENV.append "LDFLAGS", "-L#{Formula["apr-util"].opt_libexec}/lib"
    ENV.append "LDFLAGS", "-L#{Formula["apr"].opt_libexec}/lib"
    ENV.append "CFLAGS", "-I#{Formula["apr"].opt_libexec}/include/apr-1"
    ENV.append "CFLAGS", "-I#{Formula["apr-util"].opt_libexec}/include/apr-1"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "apib", "apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
