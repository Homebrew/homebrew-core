class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.4/admesh-0.98.4.tar.gz"
  sha256 "1c441591f2223034fed2fe536cf73e996062cac840423c3abe5342f898a819bb"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d07859389041c5bf1e2c03f5d2ac56a38013263ec3a7f682fbc0357aacbc056b"
    sha256 cellar: :any,                 arm64_big_sur:  "ee008a3dc86478020116d2289fc6d78dfc44d87a95b7c12c6777e8ed6b053242"
    sha256 cellar: :any,                 monterey:       "1c89962fabc1d3777f86b52920f251a053a2e9d46603a5c3642613bc281dcb10"
    sha256 cellar: :any,                 big_sur:        "e6f9a80ab0ef52a4027a6aa4cf1709f2088f0f9f51918d3f0361febe3c61a84d"
    sha256 cellar: :any,                 catalina:       "d877dfc78d057e2124d06b4826e9044b2686f19de3e84fbab1cd19c07524e6df"
    sha256 cellar: :any,                 mojave:         "86f1775a6dbca0e6309cdfed9fb83d068873f5e8183204f02cc871d013290f62"
    sha256 cellar: :any,                 high_sierra:    "2f0fd4e6cda35b4e14f6c8ba627ad7d22ee93507875b6943ea5677c857c4ab36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f34afa551d708de7ff07bd9e1e0dd92a72813f325b0720132f15fbc329aae40"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<~EOS
      SOLID Untitled1
      FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
      OUTER LOOP
      VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
      VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
      VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
      ENDLOOP
      ENDFACET
      ENDSOLID Untitled1
    EOS
    system "#{bin}/admesh", "test.stl"
  end
end
