class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/8.2.0/proj-8.2.0.tar.gz"
  sha256 "de93df9a4aa88d09459ead791f2dbc874b897bf67a5bbb3e4b68de7b1bdef13c"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "49b63a1a1b2af8b28663788278b9ccfd4c5b85333f6fbcda4435114cc81b75f0"
    sha256 arm64_big_sur:  "58ecbb4a293eefeddec447b1905b1b6afc0e75287032310390a14fb62b7f9e8f"
    sha256 monterey:       "c5d228523ab9c1a755e8b50f75d97f44c1ea6b91d95de2bfe91d94ec26130e86"
    sha256 big_sur:        "4545e76654386d639320ba48ec998ce531911c60a32a8a59d5c0d3709cc1b61e"
    sha256 catalina:       "3285536e477a5a07a1f553947e47cfd535e6f425a01c1940006e98eacd8d186c"
    sha256 x86_64_linux:   "a6edf32a6649083586286a4dd07ca9363d744035b8f233d86147cfd97517f2bd"
  end

  head do
    url "https://github.com/OSGeo/proj.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", because: "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS

    output = shell_output("#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test")
    assert_equal match, output
  end
end
