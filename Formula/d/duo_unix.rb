class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.0.3.tar.gz"
  sha256 "40ddbaf65ed40295c8d0fe12bd3d03adac1a4e3e35e921adfc3bfe6222bb23c7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "148f069d954247522b2ea4252373c2434c29c1dc80639161984569c293959dc3"
    sha256 arm64_sonoma:   "fc0b173a69d84964d44d9616ad725119dbbcb5a359473e7f8339bc3795fc0c6d"
    sha256 arm64_ventura:  "e3406c6617c72b424477d186ef26d93848b43cad42c20eef95127be81baf9a21"
    sha256 arm64_monterey: "e98d79b5654f368ec202c873ea2d9e4af78aee88cbafbab2376bc4d1391ccdc5"
    sha256 sonoma:         "7de4955e9f11895d1b4e6a28dfc114336c2d04a4624365f1ddba1a9d2cb51b89"
    sha256 ventura:        "ce5454947eb551248e26ecf6943c7a3afd396566b7ba2a46b7a23501ef913d55"
    sha256 monterey:       "9157772cb2846e60155cfe25cf99c0611cad9fa2095d9b6f1dfa499b78d58d6f"
    sha256 x86_64_linux:   "1eef942f8266c30780c182b349ca27dcf69ea31fa3eeab16a9767bfe597aad77"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

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
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
