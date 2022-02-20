class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.12.0.tar.gz"
  sha256 "a4479f893e036f38a5809d71ce47f69118f6ef61822cc1c66afccf143c5d71f8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://github.com/duosecurity/duo_unix.git"
  end

  bottle do
    sha256 arm64_monterey: "d0a13ed5c65f4f57bde81d5145ade4c2940136462b5a0b4f3f43dced52966290"
    sha256 arm64_big_sur:  "4b7eebf362ed0e9bd22ee9137d1b0effeda2e1cd21d9bdceedd71e7ee99bd0c9"
    sha256 monterey:       "e4748bebacc4747803d83ab1805390e629600f5ad8afb68cb8a57d7f0b20c30b"
    sha256 big_sur:        "919d2ef949347b5f4343c8c9cedfa7a9bce062c6c849e22220eef6ba276d4e28"
    sha256 catalina:       "172d63fa9e99f36b6f407f5b8cec6b6e8e410588740cbdfd6e45c20837b4fee9"
    sha256 x86_64_linux:   "18b8c94c610e131d0d1036bdc7f44380e2405c1e0aa3648cae9fc19b4a0126ab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
