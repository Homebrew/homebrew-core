class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.3.tar.gz"
  sha256 "1a67c3fa684072942bd5f0696158ababb1a7198d32e686ca8c1fb74f85f5d745"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e368ee56af4db589ab47db471bafec013482b5bda004654f2f9940721c57e2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4cc6671fa14f2200eceb89a1295a86b0acedd65394b30c9fd0fdcfe081a94ce"
    sha256 cellar: :any_skip_relocation, monterey:       "f96f5bc60ca81283aed500aed25d8119d19a686596fad3a89b6d36c3dc757da2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b11e38ffcfb79f6acea8865015915e8b05219349cd77da145e3eb2605463be0f"
    sha256 cellar: :any_skip_relocation, catalina:       "8a5321f528d4d2c1f8f2162bc0aa9fcf5b00e232167ccd85a0e1a3e15ab36fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae996a3f25762647aa6d4913fe13c4bac465781b71e2abf41844cd1adfb90054"
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
