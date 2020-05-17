class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/content/sw/findent/introduction"
  url "https://downloads.sourceforge.net/project/findent/findent-3.1.6.tar.gz"
  sha256 "c228eb3711bfa05c3db13521488e0a2ba73951472701cca7cd3b5d884ed42579"

  bottle do
    cellar :any_skip_relocation
    sha256 "861762ea85d5b614c84f403ae99d6e2bdad9897c7fcc49d306ea7846f79048e1" => :catalina
    sha256 "8f52dc6c2689ed411875e77a29f18138d11c3363bf665352e1bb11d0e2bbe9e6" => :mojave
    sha256 "dba900038c4e5f601ea78171ccfd02700e1c451889f1ff41b87f9283b839a32c" => :high_sierra
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
    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *[!] */, "").chomp
    system "#{bin}/findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
