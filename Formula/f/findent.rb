class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.1.tar.gz"
  sha256 "6e4ea2fdac92f62dd1a8ec13a60d98c20cbd1b21df1e65edfcda104c4717aa80"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d02e9409910fcfdbc207c6935e7ef8c1965d3659307a01561f5dfd5b6e51fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a2a342a06057c5955e42d4a190c2e3b4fbdc2b8087ca68788dd134edc32de3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43e3461e0cf961e84f04523be72d7627e58f0a699edf1217421584fdeaffc71"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed9d994bbd410c48757cf1d1efa0074b6c66276b77fedc8bd4b72ae233bf0490"
    sha256 cellar: :any_skip_relocation, ventura:        "b634fb063724ddd40ebaf36f034fc8bc7e6bdad6cad7458815ff506854553a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "0cdd467187eb8d00d843e929d21c366220848c79a72f97119d971601344a7f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed28fe27c066738182d2aebd990cebab9d48ca5674ddf43af25cda9ffdd93ea3"
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
