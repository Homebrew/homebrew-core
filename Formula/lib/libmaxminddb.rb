class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.10.0/libmaxminddb-1.10.0.tar.gz"
  sha256 "5e6db72df423ae225bfe8897069f6def40faa8931f456b99d79b8b4d664c6671"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc37a88eb58853f446041c5037084409dfd1231a3f5423baee8d7a8b6b21b328"
    sha256 cellar: :any,                 arm64_ventura:  "441488a71c14a5763e593b750a47663651d243add42bc1c6e51e24ccfe2706d6"
    sha256 cellar: :any,                 arm64_monterey: "6a0715b231f61ea2371ef793a7523b2984c2075a33a4ba2160712cd6f3f46266"
    sha256 cellar: :any,                 sonoma:         "82c006307dfad319ed834da5b0b6270b8d3a290ba042a0093e8ab267a638e237"
    sha256 cellar: :any,                 ventura:        "e34ea9b5a58f6e5993599f969f4d264a2680c54ac8b2d0d606daa5a4c8d7cbaf"
    sha256 cellar: :any,                 monterey:       "8b2b30919eceafdc532ef0996b49a615e40810d3cd8bce2a3db1777b0d51c8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "552c532eef7889d4bd30df015ff5507462022c7cd8c56dbd287119a1e3e9aec5"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
