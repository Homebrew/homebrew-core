class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.2.0.tar.gz"
  sha256 "186d3af8659093903e7c2e3e4a44717b6a502877016125242622dfa9aaa91098"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "ed5e191e34723d1eb8bddae4b5971dd2eba5c75497368d974f7e4dfcdb0a4af1"
    sha256               arm64_sequoia: "c3a62df3263a0fcea182075746ffe5301fd11be35c01812abccb841caddb90b0"
    sha256               arm64_sonoma:  "61e8b4090f241f8685f5913989b06b2592050f98d7aa0a920a1951509afbed3d"
    sha256               arm64_ventura: "82ef15d990999217957a13bf354312c9f7c2fc2771dc45911340deb5e8ee5dc1"
    sha256 cellar: :any, sonoma:        "bbaffb904216e3dea759c385265aa2d86998197f5311f333ecc10be173c0df5c"
    sha256 cellar: :any, ventura:       "49f259e1d33e26074c22f620b7f5b0fb31c2dbea9e6ae3d92e26e07952033556"
    sha256               arm64_linux:   "a33c8ef5fcff310580983e68e3125a5cbff8e5376d69f48e90ebca8179bd2b16"
    sha256               x86_64_linux:  "c72420eabe0a8175683dcbc39470e4589c4791c5d014bbe9fe252b872899ea90"
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
