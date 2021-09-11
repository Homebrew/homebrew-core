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
    sha256 cellar: :any_skip_relocation, big_sur:      "19b727e336b0e9040155f784082823cfcbc9c4b857b633836b4f51fc2210a643"
    sha256 cellar: :any_skip_relocation, catalina:     "24a8f26724d9e49ca1fcd4b87bccb4bc1f120205e54fbc8806a654683020ba3a"
    sha256 cellar: :any_skip_relocation, mojave:       "d3a515ec3d972eb63943d112ce9cb3cdd7a0835394205d971fa7fdf488dce210"
    sha256 cellar: :any_skip_relocation, high_sierra:  "bec64c83b6ad2769e8fa36245796ed743a6a1f6c20b6c17e49b495b3e7bab7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c829b9d4cd228e9152951b5dbce0f06d97d9201f4aba2e4f993e978f96f68aa1"
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
