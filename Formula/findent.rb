class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.2.5.tar.gz"
  sha256 "bb8b8852a43444a4fe9bc2dc94dba59bff9912f0fb7df2a1af70f1012d211a59"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e5a7beb16d379418feed1bf0a09f4797f79ffbf7f08a1c1979ae78eb88bc401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "421593e9181a0b27e6204e1ec6890eb658357f6987089cfdd0902a9522e652ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "054f72650aba62b06fc435085906d72a311914f816358eaec4a6f49c94d2b94c"
    sha256 cellar: :any_skip_relocation, ventura:        "e121f00dadd1637588677e0ff0eca41045e8e16d296a8bb58ab3a2f6d43b95be"
    sha256 cellar: :any_skip_relocation, monterey:       "4902b19c53ffac5517065d85112060d06904d5157a3584b58d8752a37b1d62af"
    sha256 cellar: :any_skip_relocation, big_sur:        "57e35571c405ca206b87eac801964b17ae234db9d7fe870863740de0a85fa2f2"
    sha256 cellar: :any_skip_relocation, catalina:       "4f4ecb21d0049d8256dd6c5b4b5a102a024c4b35f9a86c670f7580416792372e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94eedf7cc8154de296bc667849abf67872346b1563cfa85d2db18a25bbb7e336"
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
