class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.2.tar.xz"
  sha256 "8ae3fb5b1fe7436e1f565060acaa3e2918fe745b0e4979b5593968914fe2d5c4"
  license "X11"

  depends_on "pkg-config" => :build
  depends_on "xorgproto"  => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = std_configure_args + %w[
      --with-bzip2
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mkfontscale"
    assert_predicate testpath/"fonts.scale", :exist?
  end
end
