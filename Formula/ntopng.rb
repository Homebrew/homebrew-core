class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/2.4.tar.gz"
    sha256 "86f8ed46983f46bcd931304d3d992fc1af572b11e461ab9fb4f0f472429bd5dd"

    resource "nDPI" do
      # tip of 1.8-stable branch; four commits beyond the 1.8 tag
      url "https://github.com/ntop/nDPI.git",
        :revision => "6fb81f146e2542cfbf7fab7d53678339c7747b35"
    end
  end

  bottle do
    sha256 "229f5e24c1413f5bb574ca8cca632c2819f579613ce0b2404a03fbc5c8ba9600" => :el_capitan
    sha256 "fb8f0f0a8c7fe19fdde2d36c4c58e3e76c226be2df7b9e4dc5eeae3060bbe8de" => :yosemite
    sha256 "a407931b90378f676c99a21105da89d5831a605360c9bbc80a47372120241eb2" => :mavericks
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  option "with-mariadb", "Build with mariadb support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "wget" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "luajit"
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql" if build.without? "mariadb"
  depends_on "mariadb" => :optional

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
    system "#{bin}/ntopng", "-h"
  end
end
