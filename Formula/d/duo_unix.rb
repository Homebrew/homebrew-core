class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.2.1.tar.gz"
  sha256 "3461d6f5818388ecf84f0a2ef97a1a7af5f9dfb9fe09f3a0a5bc4717ba0be027"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "b354b4407675279464957db28281e1298e495be6ac1f67b3cb37bf9c41b570a8"
    sha256               arm64_sequoia: "bce0a9f9c0a4a0956dbc87a25fa3b1aab66b75be56efd83b55071ffcd0dca72e"
    sha256               arm64_sonoma:  "f4e6ba38f45ca5d24cb8d2590a35198703be47a081314a2602218ff3b939539e"
    sha256 cellar: :any, sonoma:        "3805539d83ca20ff03edaf05668158b3d32f97eb75d5a22c2d15884f82c3d316"
    sha256               arm64_linux:   "d909789b3dccacdeb365f20e78e1741c8ce5518ebbbab825c3c0889782ef7142"
    sha256               x86_64_linux:  "19c17623d2f22249ea692c36cda0bdc533d35fe7b9d7fc9da20622eb2f9bd7dc"
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
