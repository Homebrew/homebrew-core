class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-1.11.4.tar.gz"
  sha256 "2fcba3e50fd477699d013c789ffc73a0b10c204d25c455abe7c81a2ecd886579"
  license "GPL-2.0"

  livecheck do
    url "https://github.com/duosecurity/duo_unix.git"
  end

  bottle do
    sha256 arm64_monterey: "095e85a126b7a377ecdb654572f8d1d1bdcdfd37e82be4d0f967c0a276255ee4"
    sha256 arm64_big_sur:  "e323d478329b8b50be30253b7fd8b3f0387d5fd06a1047c7d18d6911860a095e"
    sha256 monterey:       "4f047f8edb256953afa519254fffb821a5e62a6ba8e5ea57198aba25d807411d"
    sha256 big_sur:        "dece3829732fe41b3346b5de6f04b921ab22641c39eb45b87e91a0795a384e67"
    sha256 catalina:       "67a6ff6605578e287fc862f6fb2ee9360dea7c22f8fbaa97a1bf18dd13db5ec0"
    sha256 mojave:         "753e3f0d60c4c0404a6e347d052bc1ed4bd1e66b43170675549a36d4fe736f25"
    sha256 high_sierra:    "8e707bc378fa13dfd92fb39e0de055c58f2470973fe80edc41bf500e4863128a"
    sha256 x86_64_linux:   "941aa90695f3bfbffe6aebcc7c73c8325a5de5355840b451604278172bd3fba2"
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
