class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://maxmind.github.io/libmaxminddb/"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.14.1/libmaxminddb-1.14.1.tar.gz"
  sha256 "ca5c87d41339f8bc4daabb53e8a9356b3c995f2d2419b85d7bff823b2ecc252d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2f0ae54b073b78c2dc1d526bfbb4882bac43fc9bdde1992aa81bb9a1c7aa7c47"
    sha256 cellar: :any, arm64_tahoe:       "29fad65e40df8a8665da3b5cd76f1488aec0161ac0da386bd66e01930aa246a1"
    sha256 cellar: :any, arm64_sequoia:     "a39f2ebe92607371937c715c6a22e1fec6895fb5e5f48682a33ea24be67abb67"
    sha256 cellar: :any, arm64_linux:       "c2ba2e69b493b3bb0bee3c337eacc662c5b199588ecaad8acb28a7865d2d3c79"
    sha256 cellar: :any, x86_64_linux:      "572434444abf40217879536e0bafe66b112e261fe09d3d0bf7cd545f45778f72"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system bin/"mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
