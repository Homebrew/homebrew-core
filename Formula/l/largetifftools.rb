class Largetifftools < Formula
  desc "Collection of software that can help managing (very) large TIFF files"
  homepage "https://pperso.ijclab.in2p3.fr/page_perso/Deroulers/software/largetifftools/"
  url "https://pperso.ijclab.in2p3.fr/page_perso/Deroulers/software/largetifftools/download/largetifftools-1.4.2/largetifftools-1.4.2.tar.bz2"
  sha256 "a7544d79a93349ebbc755f2b7b6c5fbcd71a01f68d2939dbcba749ba6069fabb"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?largetifftools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84f779bd4774fc9825d78fc4b2b485652c52bb3b06dc4147fbf70efc99c61c61"
    sha256 cellar: :any,                 arm64_sequoia: "e7ad30862ae1b715271064e5487dacac835007e1d1465a61796192d33849ef69"
    sha256 cellar: :any,                 arm64_sonoma:  "8e289d1b6b87e41764c8ff7831fffd5ad6b2871a97531344de0379f7a29719fa"
    sha256 cellar: :any,                 arm64_ventura: "d6aa8ea83b7d6ed7f73c35dcbb531f3088d4a07e419a9b6945848249874cb6fb"
    sha256 cellar: :any,                 sonoma:        "1d4d9cce695d92295f325ca875c16b7a4c2cf57223ce8e28f05beca25de519ee"
    sha256 cellar: :any,                 ventura:       "58bde27fe7d7cf8a22ae7feac74afb4c88d54af82b1d254f5b8ffcf6a563193d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba139ab0c3a04448191f5596e5d233824f672fb3e3bacb166c4b7e5e9363fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd6458d660821a0038f8ce37977442e31e638dd8a0e0f408f2cc3512eb1ea404"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  on_macos do
    depends_on "webp"
    depends_on "zstd"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tifffastcrop", "-p", "-E", "0,0,-1,-1", test_fixtures("test.tiff"), testpath/"output.png"
    assert File.size?(testpath/"output.png")
  end
end
