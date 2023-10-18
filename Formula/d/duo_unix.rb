class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/duo_unix-2.0.2.tar.gz"
  sha256 "0a2ccaa8e2fef3cca00cfdf9e1310df4ec1253aa7720e37bc0a824a5c2f1433d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "dc1aedccb7db8b50dc31d81d13df16ead485d8a46f0ae0d6ab8ff20d468fdbf9"
    sha256 arm64_ventura:  "9a6bbfe6c75da709bdf0afe6018f2e6395ac27727b5672db37b9bf6a56b98222"
    sha256 arm64_monterey: "a56165902f8088823615fe8e7e8a3e1675bc2f06e2d1e5033f60406c6d072768"
    sha256 arm64_big_sur:  "798f6731f3545946c7fbc89822f34ba8f5e969a11ba98b396b9be4cd66952276"
    sha256 sonoma:         "f14e7a48123f94753b80fe0b4e1b3017f1782745b789ef2ef09f5d764f9b1dc4"
    sha256 ventura:        "d8fcb91bf99c57dbaac23d2018989fe732dae914ac3ef4e5a5a74fbd347f18d2"
    sha256 monterey:       "f6b1fdcb60764a5bc05e540693ca61f5ceb46dd6c9cce219e7a4bbaca47148b0"
    sha256 big_sur:        "5101c623cdda9d871dde50690614087b2494461f4c249c1f8e9194665afa4bf3"
    sha256 x86_64_linux:   "73dcc6c177ec868d564a3c73f241c58e85ef4754852d2bcc6e6086d8ad6b6cb7"
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
