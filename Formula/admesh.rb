class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.4/admesh-0.98.4.tar.gz"
  sha256 "1c441591f2223034fed2fe536cf73e996062cac840423c3abe5342f898a819bb"

  bottle do
    cellar :any
    sha256 "d877dfc78d057e2124d06b4826e9044b2686f19de3e84fbab1cd19c07524e6df" => :catalina
    sha256 "86f1775a6dbca0e6309cdfed9fb83d068873f5e8183204f02cc871d013290f62" => :mojave
    sha256 "2f0fd4e6cda35b4e14f6c8ba627ad7d22ee93507875b6943ea5677c857c4ab36" => :high_sierra
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
