class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.1.tar.gz"
  sha256 "8f24ff072c17201703f68f139d31d82e239001b9612be4ad09c31e495372468d"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "34ce5fbe3862892bec535178bd21c1d7583d1aa24bfaeab563c17260d6dde688" => :high_sierra
    sha256 "2ce461b056e8501f943d3aad2d2a16365e614a75d5064d1cecb8c55b874173fc" => :sierra
    sha256 "98ba26ff046536172ae69703946409d5714345904c07728b69a374da39669ea6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libspectre" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libarchive" => :recommended
  depends_on "webp" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
