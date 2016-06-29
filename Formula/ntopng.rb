class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"

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
    sha256 "21c5efd12b1c2871d076bed943c23a337fa626503d793c570894da8c9a85a464" => :el_capitan
    sha256 "6928cd197c059e95f481edb212dced7236cbc803dfef3c4284eed10191904b57" => :yosemite
    sha256 "168c94b9f301f7103bc5e9493b62a158e314690960eb854e9b7305083f705406" => :mavericks
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
