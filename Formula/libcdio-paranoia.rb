class LibcdioParanoia < Formula
  desc "CD paranoia on top of libcdio"
  homepage "https://github.com/rocky/libcdio-paranoia"
  url "https://github.com/rocky/libcdio-paranoia/archive/refs/tags/release-10.2+2.0.1.tar.gz"
  version "10.2+2.0.1"
  sha256 "7a4e257c85f3f84129cca55cd097c397364c7a6f79b9701bbc593b13bd59eb95"
  license "GPL-3.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libcdio"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--without-versioned-libs",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match(/cdparanoia/, shell_output("#{bin}/cd-paranoia -V 2>&1").partition(" ").first)
  end
end
