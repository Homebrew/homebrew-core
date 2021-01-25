class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/content/sw/findent/introduction"
  url "https://downloads.sourceforge.net/project/findent/findent-3.1.7.tar.gz"
  sha256 "42bbf3fd80c14bb44fd18fa73aa53596829f4fb2bacabe57733eb8a9e4f00bb2"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "19b727e336b0e9040155f784082823cfcbc9c4b857b633836b4f51fc2210a643" => :big_sur
    sha256 "24a8f26724d9e49ca1fcd4b87bccb4bc1f120205e54fbc8806a654683020ba3a" => :catalina
    sha256 "d3a515ec3d972eb63943d112ce9cb3cdd7a0835394205d971fa7fdf488dce210" => :mojave
    sha256 "bec64c83b6ad2769e8fa36245796ed743a6a1f6c20b6c17e49b495b3e7bab7dc" => :high_sierra
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
