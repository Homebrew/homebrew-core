class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.16.tar.gz"
  sha256 "f0d19d8be0fd961d07556f85dbea1d95f0d38728a45dc0f2cf92c715e4140542"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "21266fa80373c2fffb69d8962f42a3d97e41aabfea6afe203eb02623760240f5"
    sha256 arm64_monterey: "e8d3042fd923158ab250600c7a465010ea8c329e11326f36a2d10f9406a4e827"
    sha256 arm64_big_sur:  "98325540be8b32bfc44cc1a7ebb976a11a95d63140aba964085e4df8b6af59a3"
    sha256 ventura:        "16da9b4776a14debcebdab692318501670f66810be6ede03596f150760832d71"
    sha256 monterey:       "ddd36ac6cc9fbf5e585bbfc37f1dc595f207691ed702900b3354866c411ddaac"
    sha256 big_sur:        "4ec9fe099c857e2024e854462641e5620056585059d7a587ca6322df6d1c9a5a"
    sha256 catalina:       "7b208d7bfd479b71ee86eabfbba86e72d9a354ff28b56f6dc1afb4121617d402"
    sha256 x86_64_linux:   "6fb8d354d0807ff8a643f13ae974cde5f0f1d76c51e904dae4b9b9a40b1ee927"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--without-gui"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
