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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e05313660b112c576fcdbd23171543a334e915590848d5b2c853c3e655de403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f54e465f61257514398c7b022fca74504fb839eb680769190a4704bbeee8c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa5b1e4517d5697f9ec9ce981a03a49e568df8a05ee0a51b817c774d16902a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f816b5e1e13a2f70c5771b86391200195c0f4589d2b7177b6b76bf058faf0456"
    sha256 cellar: :any_skip_relocation, catalina:       "c5cf9be6cdac0f66237ffe6eaf7b8dbf9c8b2699ce0b2928fd8f901ed1880baf"
    sha256 cellar: :any_skip_relocation, mojave:         "889ed0f2d7373de18390c317e7270aa57a394f7796aff07d8ca9d6b7422bc2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62243f247c4ec6581b1cc0bac09cee298e20cc541199f4c273cd6bb33d2b1e65"
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
