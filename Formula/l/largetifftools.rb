class Largetifftools < Formula
  desc "Collection of software that can help managing (very) large TIFF files"
  homepage "https://pperso.ijclab.in2p3.fr/page_perso/Deroulers/software/largetifftools/"
  url "https://pperso.ijclab.in2p3.fr/page_perso/Deroulers/software/largetifftools/download/largetifftools-1.4.2/largetifftools-1.4.2.tar.bz2"
  sha256 "a7544d79a93349ebbc755f2b7b6c5fbcd71a01f68d2939dbcba749ba6069fabb"
  license "GPL-3.0-only"

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"
  depends_on "zstd"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tifffastcrop", "-p", "-E", "0,0,-1,-1", test_fixtures("test.tiff"), testpath/"output.png"
    assert File.size?(testpath/"output.png")
  end
end
