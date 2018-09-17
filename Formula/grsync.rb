class Grsync < Formula
  desc "GUI for rsync"
  homepage "http://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.2.6.tar.gz"
  sha256 "66d5acea5e6767d6ed2082e1c6e250fe809cb1e797cbbee5c8e8a2d28a895619"
  revision 1

  bottle do
    sha256 "f4f062368eb98e973ed137c8f01ab04b626871b5d37a1a2453ae631352236f2f" => :mojave
    sha256 "8bf6f5db117d7f86ec7962263479fc465a27c68efe5967b31b663ee5a52b75ea" => :high_sierra
    sha256 "d79f87af06cd936248834e04bd87006f3839fbb70b48f195f84b600fdf65f4ef" => :sierra
    sha256 "b47c5cd30b84d999349e938281966586697485ff23bbe8af96e18977653c94a4" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert_predicate bin/"grsync", :exist?
  end
end
