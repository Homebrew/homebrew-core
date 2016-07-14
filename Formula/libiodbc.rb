class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "https://downloads.sourceforge.net/project/iodbc/iodbc/3.52.12/libiodbc-3.52.12.tar.gz"
  sha256 "51c5ff3a7d9a54202486cb77a3514e0e379a135beefcd5d12b96d1901f9dfb62"

  bottle do
    cellar :any
    sha256 "633bee4aad14f908a8b85fcbd8f5be2f0802f24b83fc5373f43111f0a04ef341" => :el_capitan
    sha256 "788c2b7746d436b6d90860f0aeaae96c34e94b890700a6f9e752604cffa1c030" => :yosemite
    sha256 "b47fd8f3e58259fecf6af5e6f7bab7343007b4fc34d04ed0d3885b8c6c4a48fd" => :mavericks
    sha256 "c70f91b15fd9efffb36f3849f8e1f66314fbf6d697ad6821aac8b160b7441b1a" => :mountain_lion
  end

  keg_only :provided_pre_mavericks

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iodbc-config", "--version"
  end
end
