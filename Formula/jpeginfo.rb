class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.6.1.tar.gz"
  sha256 "629e31cf1da0fa1efe4a7cc54c67123a68f5024f3d8e864a30457aeaed1d7653"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/tjko/jpeginfo.git"

  livecheck do
    url :homepage
    regex(/href=.*?jpeginfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b223bfedf94aca1532a772bb7fcde2a9613dd28d27a79dce36d956727a30b829"
    sha256 cellar: :any,                 arm64_big_sur:  "883d13008806a89bd05f612ffd27940a5985f47ad9c950af76f719b6a781bb1e"
    sha256 cellar: :any,                 monterey:       "4b3617a321a243d012107f4f62c650e4e980712ca0e0402c592f37a9db95e2ea"
    sha256 cellar: :any,                 big_sur:        "27bb3588438853fb065ef36885dfea66a2e066dddc7025ea8fd6295682ff8b83"
    sha256 cellar: :any,                 catalina:       "0f0cc493a38a1a701a51f6aa2cada9b8f248c228a72ce30c451d5cab2906e8c5"
    sha256 cellar: :any,                 mojave:         "71cbeda00d00f513847a88930a6851b00ab9811fb6ed37d0617eaee5e86decf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e4419c51af044e57adaf7d6d360bd99ad1bc16d4d837d060df84fe308bb4d2"
  end

  depends_on "autoconf" => :build
  depends_on "jpeg"

  def install
    ENV.deparallelize

    # The ./configure file inside the tarball is too old to work with Xcode 12, regenerate:
    system "autoconf", "--force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
