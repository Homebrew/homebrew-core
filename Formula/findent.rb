class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.2.tar.gz"
  sha256 "e54b96f40731a9c887c09b8ed618851467b60c3dc6a98c551bbed8e7805e7fb5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c2b26be712bc1bb1ce379e61f00310b7e16c21b407a3bd324033b701503fc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8b268dff924a4eef8ac6c1b8a9483eb507a75f0201b7dd6378d15fb58b1ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "0bd83c8652c99951f4b821fe365448c435d4b5f19c69d0bc23dbc1a7308e1411"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe2bc46144328becdc142de53d172c2c41bb536a0519cf14dc6404b91dd1c41d"
    sha256 cellar: :any_skip_relocation, catalina:       "b7f1fc9ce343ada496989a2a7d32498da3db143e034411906c1396a05a3d562a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670cb312112c73b5a2bf72e1e6a7d1d9c37363d5816670fa1e4011c8fabc1803"
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
