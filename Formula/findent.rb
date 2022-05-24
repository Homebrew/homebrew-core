class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.0.tar.gz"
  sha256 "6e6411eecfe6586d991ed7dbeeb47859fcfe3655615619912703da6da6bdc3c2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337ccd197a09fea90aa891fd3428d79ff2cae9233febe1beda55eeb21fec61f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a6870dde326fec22ed9e690cbc8ce977df23565ef673e6825b6f1736124935"
    sha256 cellar: :any_skip_relocation, monterey:       "067e0c7c1dc8459af34cb9708af960abb6ad28db3821832e5325d88362219c8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e640f6b1b54b0406218fb491d2b8034ac3815b55eac07d578ab2395f1b43d48"
    sha256 cellar: :any_skip_relocation, catalina:       "f412962a429c4c9de4cd411e7ffb1eeb3291ef3fa2a6e58367aa672e7ee231b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b84a89de673ea29d6fa795476ea4f7e3d30727cfa036b11149798fbd62bf625"
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
