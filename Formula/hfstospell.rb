class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.1/hfstospell-0.5.1.tar.gz"
  sha256 "ccf5f3b06bcdc5636365e753b9f7fad9c11dfe483272061700a905b3d65ac750"
  revision 2

  bottle do
    cellar :any
    sha256 "080d7ec2bee989e5af8dc7923da5c0d9b9756a32d5e56c279068ee7702afbad7" => :catalina
    sha256 "a2f8c52c1dea2796d522a2272d58a250005e89ba89381990a6a2fc5b2d69ca6b" => :mojave
    sha256 "b952fd1e7bc1aa35cb83a8030905973c6e1e141879a5481f2e8936fd32562016" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
