class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.6.tar.gz"
  sha256 "1ef4d1cfdf062d079bead6ace85297312349b5bf93cadc8960d6f283d7e31be2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e2a69d8afb098fe9ae8847879fae2ee7df61b145aae3809a056f912463b079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e60c911d6a583ef4249aefdb0da42b35e837137d4c0b2aec7f36f31e81d2674c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "973186bf7c3f6a9e5003770938a1b326be10d5135e8b83ceaa3f13ccc445d7e5"
    sha256 cellar: :any_skip_relocation, ventura:        "1e80c5c66200c5eb8f21a7df9c6c8a78a9cbecb906adfd9c1b2280ade5b642ec"
    sha256 cellar: :any_skip_relocation, monterey:       "5d67f1420b4de8547e47b06f3795936adb36625c9f481dab97980aac207f2434"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeaa9cc5e5dce4d09442576ecd28550aba73b75c837e24b960c3c9090cb6b566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03d7666b756ac12c14061e793cb00e31f37d05a20b78c7fb048b5bac60aa553"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath
    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system "#{bin}/findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
