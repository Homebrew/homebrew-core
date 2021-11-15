class Bookloupe < Formula
  desc "List common formatting errors in a Project Gutenberg candidate file"
  homepage "http://www.juiblex.co.uk/pgdp/bookloupe/"
  url "http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz"
  sha256 "15b1f5a0fa01e7c0a0752c282f8a354d3dc9edbefc677e6e42044771d5abe3c9"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?bookloupe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f981bcea12ecb29401b723391ccf8a7b47ba68bf57dd7277cc4474fc3e0767af"
    sha256 cellar: :any,                 arm64_big_sur:  "52b3382b76c8ef2e8edd46e3bcbe56620d659713f0e8fc4a4fe3e109fc25d7ca"
    sha256 cellar: :any,                 monterey:       "b2df92066e4e19f5a6c9eb4c0784b9f736e1e9043dcb83798e7f2bdf02295942"
    sha256 cellar: :any,                 big_sur:        "7ccdee4a97e6c705e478e38aeca1648b06a39c2edfcfa807a4a07ab12eb0d3c8"
    sha256 cellar: :any,                 catalina:       "83e920e882a00717b094b14477917ed477fa3ab9ae02433d79bf4d374d5723a6"
    sha256 cellar: :any,                 mojave:         "f5e7f38cfa342d15025f798e9476a7091d3dbd60a15a6635d9fd784033dd531c"
    sha256 cellar: :any,                 high_sierra:    "8cade7bb36828e32d7be412d29404748198079745defd97ed2ec533ff91f5645"
    sha256 cellar: :any,                 sierra:         "564cdae8b088da04903efd886b33ed12e5673a64866679f67b37acdb68bf539c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7cdc047eeed0574f7b0c8bccae751fa4b047b0a2aa30d71153960b75b52444"
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
