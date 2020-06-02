class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/content/sw/findent/introduction"
  url "https://downloads.sourceforge.net/project/findent/findent-3.1.6.tar.gz"
  sha256 "c228eb3711bfa05c3db13521488e0a2ba73951472701cca7cd3b5d884ed42579"

  bottle do
    cellar :any_skip_relocation
    sha256 "da0eefdb70f76e0f31443b510725d483941a0ba58c7a7c2bd85e2934ab8ed04e" => :catalina
    sha256 "bf2e8d595feae56fd6a8568abb08c3d3b9d6e7d7da2a1e0126a8bfa39eff7ad0" => :mojave
    sha256 "93181b8b1f49db914b56caf888313bbba6223f9d9dffa39e12c2985bebce0f55" => :high_sierra
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
