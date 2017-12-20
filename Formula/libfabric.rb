class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.5.3/libfabric-1.5.3.tar.bz2"
  sha256 "f62a40da06f8951db267a59a4ee7363b6ee60a7abbc55cd5db6c8b067d93fa0c"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "6a03113916120d748b750ca4e7716c1f15b29539de0d91737f2db3fa68c801b1" => :high_sierra
    sha256 "47a662abb4abfe93f272ce0337675daca692e1076dc7d51180e8d085fd8777f4" => :sierra
    sha256 "c6f9f04517d7675162610ac0e01c98f5f3d07785663a75a3caf4575dae177435" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
