class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-2.1.0.tar.bz2"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-2.1.0.tar.bz2"
  sha256 "8550e9589dbd594bfac93b81ecf129b1dc9d0d51e90f9696f1b2f9b2af32712b"

  bottle do
    cellar :any
    sha256 "3ec17ce98e129db74cb883941e429286b9ab762c740dcb6ee8c7ff077d6e3304" => :catalina
    sha256 "55014a60373e44384aa7f797c613ccd5289c55d759c3521b7e5d6819ff54b2ac" => :mojave
    sha256 "32604fb219cc4e59e5eb1e0937b320edfacf31d97f04b9a5fbfcd4354a6a56d0" => :high_sierra
    sha256 "61095f7c4888b1c0e022ec9eb314fe389feae1eb030d65e7d91512515528e439" => :sierra
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/cd-info -v", 1)
  end
end
