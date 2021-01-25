class Bookloupe < Formula
  desc "List common formatting errors in a Project Gutenberg candidate file"
  homepage "http://www.juiblex.co.uk/pgdp/bookloupe/"
  url "http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz"
  sha256 "15b1f5a0fa01e7c0a0752c282f8a354d3dc9edbefc677e6e42044771d5abe3c9"
  revision 1

  bottle do
    cellar :any
    sha256 "7ccdee4a97e6c705e478e38aeca1648b06a39c2edfcfa807a4a07ab12eb0d3c8" => :big_sur
    sha256 "52b3382b76c8ef2e8edd46e3bcbe56620d659713f0e8fc4a4fe3e109fc25d7ca" => :arm64_big_sur
    sha256 "83e920e882a00717b094b14477917ed477fa3ab9ae02433d79bf4d374d5723a6" => :catalina
    sha256 "f5e7f38cfa342d15025f798e9476a7091d3dbd60a15a6635d9fd784033dd531c" => :mojave
    sha256 "8cade7bb36828e32d7be412d29404748198079745defd97ed2ec533ff91f5645" => :high_sierra
    sha256 "564cdae8b088da04903efd886b33ed12e5673a64866679f67b37acdb68bf539c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["BOOKLOUPE"] = "#{bin}/bookloupe"

    Dir["#{pkgshare}/*.tst"].each do |test_file|
      # Skip test that fails on macOS
      # http://project.juiblex.co.uk/bugzilla/show_bug.cgi?id=39
      # (bugzilla page is not publicly accessible)
      next if test_file.end_with?("/markup.tst")

      system "#{bin}/loupe-test", test_file
    end
  end
end
