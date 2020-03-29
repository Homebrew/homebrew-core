class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://downloads.xiph.org/releases/ezstream/ezstream-1.0.1.tar.gz"
  sha256 "fc4bf494897a8b1cf75dceefb1eb22ebd36967e5c3b5ce2af9858dbb94cf1157"

  bottle do
    cellar :any
    sha256 "5dbee1cca793b44cd470bd858b3c6f53bd82c48609468fefe11fc79ba495fe56" => :catalina
    sha256 "fe97ee0a48df55d159cbd9f9cb7c066cc003ff430fb211f83a95df41a2e555e2" => :mojave
    sha256 "7714b3b155984c561dabce8a39c2668658cce995ee582aaca387fde476b38914" => :high_sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libshout"
  depends_on "taglib"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
