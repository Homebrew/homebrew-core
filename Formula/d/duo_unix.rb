class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.2.2.tar.gz"
  sha256 "4ff899ecd363bc218d770ce81b4ca76b0eb4c479c07ccaadeaa86e638fa1ac34"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "91ce5f2f7a0d8ae8d71580f4c514d2f353648aa22ebb027d3bbb94f1dba6d8a9"
    sha256               arm64_sequoia: "b3e93286a7ad7638b9adbc2fdf9c387a8cab50abcae6402e7a9c639cecc528a3"
    sha256               arm64_sonoma:  "8957b178e68f16a2028867b4ef79f0d1068379f3ba6c402bbce28f544ff5401f"
    sha256 cellar: :any, sonoma:        "de880cbb8dd47cf2a4c44edf4f135703e557abf12a1521a694b9480aaf6f7075"
    sha256               arm64_linux:   "334af1ff689e35833eb8186c46fa08e1afba45f92d8603c154f799e4a3962984"
    sha256               x86_64_linux:  "7eb7f1e336f4acf75dcf0f4dde25e0ecab02d8fc3a39660aaf0d899e947f260e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    File.write("build-date", time.to_i)
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
