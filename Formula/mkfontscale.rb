class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.2.tar.xz"
  sha256 "8ae3fb5b1fe7436e1f565060acaa3e2918fe745b0e4979b5593968914fe2d5c4"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51ea1294320fca4ff637100bcccfa7f288b0bd6ba1e06515e40a8189486cb191"
    sha256 cellar: :any,                 arm64_big_sur:  "22414e6c76bc214188dfbae32374613e4b26a8834d1ab9a2017aa3e77861e5cc"
    sha256 cellar: :any,                 monterey:       "52d2ac9c81ff9fdd9bdf3485fc99604280fa61db1f1056e82778fd0a70df909b"
    sha256 cellar: :any,                 big_sur:        "5f75b30ba350f02b41aaca41a8de3a8435665674efc6e2dd61e495b55481e1b5"
    sha256 cellar: :any,                 catalina:       "ca3eaaf699b21debca368afb2351f35e2c69bba294dcf68756ef7b60e627b444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3c8d69f29f369b1164a7a148fc5a41fbb83cdb88427efc06c307a76c3570cf"
  end

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
