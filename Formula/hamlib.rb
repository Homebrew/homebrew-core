class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "https://hamlib.sourceforge.io/"
  url "https://src.fedoraproject.org/repo/pkgs/hamlib/hamlib-1.2.15.3.tar.gz/3cad8987e995a00e5e9d360e2be0eb43/hamlib-1.2.15.3.tar.gz"
  sha256 "a2ca4549e4fd99d6e5600e354ebcb57502611aa63c6921c1b8a825289833f75e"

  bottle do
    rebuild 1
    sha256 "b77f0a84620a39f0622d6b1e0672778d13143484b7054e2967852fc37516f951" => :mojave
    sha256 "60e67d17ef2573f5022e5bc85e70c0ca3bb42d273b9b079b465b5ec6108dffe7" => :high_sierra
    sha256 "66d07ea64a912f95f989638124fe14658bfed6d34b609b50ce33691f06fae0ed" => :sierra
    sha256 "d4e86dbc6d9bf5e0b4a1c1bce2471e90becf05b19b1c595952c94b3bda91e0db" => :el_capitan
    sha256 "31a75a43cf17a17d35ee0c57048522e73de7c69f43279b45c766a903b5239372" => :yosemite
    sha256 "6d9dd131db4baa70355822033257f822e029aa167b6c43643419bd75ef06395a" => :mavericks
    sha256 "0e78439f806f68ae1ae36fa3e5315d13cbabf6da714571eec9816945a90b2985" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
