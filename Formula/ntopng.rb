class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  license "GPL-3.0"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/4.0.tar.gz"
    sha256 "caf3aeec5c66eca7ddc3a1d4edc4a109b6c963a22bfcf6843e402a569c8e12a1"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/3.2.tar.gz"
      sha256 "6808c8c4495343e67863f4d30bb261c1e2daec5628ae0be257ba2a2dea7ec70a"

      # Contains an API change which ntopng 4.0 uses.
      patch do
        url "https://github.com/ntop/nDPI/commit/e4512dbcb9e1db0500290b712257e501d1440d71.patch?full_index=1"
        sha256 "b753532c7c4e68bd20ac432e4ea2159b38609ee7bf6296e96b511222813cc633"
      end
    end
  end

  bottle do
    sha256 "0f5da1b5b0fe34429ce4c85d246117ccae35d6cc91db37b0606bdcd2cc8a1383" => :catalina
    sha256 "17616993b42436771976fd8a55bd23147d446e52956f5f96e4fa6685f7c75561" => :mojave
    sha256 "173a972b8696abeb4f645c2a2ec84fbe5e82b01ff66fa8ef0769906304af65b2" => :high_sierra
  end

  head do
    url "https://github.com/ntop/ntopng.git", branch: "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", branch: "dev"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls" => :build
  depends_on "json-glib" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq" => :build
  depends_on "geoip"
  depends_on "json-c"
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "mysql-client"
  depends_on "redis"
  depends_on "rrdtool"

  def install
    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath/"nDPI").install Dir["*"]
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-V"
  end
end
