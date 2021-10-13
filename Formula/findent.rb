class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.1.2.tar.gz"
  sha256 "5e09cd97b9a464a3a8a486e5efceb589c1697a59ee9815f792f4f6d785d91a9e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "0ee5a1228898bc222f04076546701d067c67c02ae2c22b543838cd10d4b677c7"
    sha256 cellar: :any_skip_relocation, catalina:     "9ae723ffe700b49e20935ba897d62def51e24cf459ee00a1e770d374bd31cb06"
    sha256 cellar: :any_skip_relocation, mojave:       "f9a2502784da94f40412d65e488d9e7f0410a1da163b387ced45e030effc4061"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "df6b341648495a84bb298258aacb816d5afb86ddc3058417ecdabe58d805fc49"
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
