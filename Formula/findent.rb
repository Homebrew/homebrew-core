class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.1.1.tar.gz"
  sha256 "d51a426d565da519061eada602d17dea7f37bc8afa4a337ab7083784bb8b0f34"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "4dfb18b69c58a7fa48d54072829f63f1588a43e0e95d5fc970fd9a37397a2d92"
    sha256 cellar: :any_skip_relocation, catalina:     "0baa0d330bd9c5bf4ce35263736819541f31a8af1d1289472bf0e3a364a20446"
    sha256 cellar: :any_skip_relocation, mojave:       "d8e2ff05dfc1f72761614710a28ddbb93bbcb550a79452eb0aed35bd9e2000ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ab21e74bb78bd44418ad39b5a630626ece59e07a9eaf5fcbb069e93661699b87"
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
