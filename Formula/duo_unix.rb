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
    sha256 arm64_monterey: "1457a1359599d6cb19c628162b4d88557ce9b12a772d56847ee224415f9c680a"
    sha256 arm64_big_sur:  "64eb033ebb55d7967cbec701c231788d9d4068e24b5b5d8e9738560dfb84690a"
    sha256 monterey:       "afe4984d8ac5b0523e115d9be26d7ac7db427988ab5b984b9a71612caa9244e2"
    sha256 big_sur:        "bd7b8e00a0429f7126cc1073afec7b5e40d4cf48a55ee1a15fac4fa1bf56eb47"
    sha256 catalina:       "e55e0de7ff5fe08d58f7a8dca4239d5b0d2ce9fa65202fb490bbdc5e6325851e"
    sha256 x86_64_linux:   "bfe161f3e7b59719cc300ac792dcf4dd3a75d2952669d918ede56c27d2c00828"
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
