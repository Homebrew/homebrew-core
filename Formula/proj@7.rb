class ProjAT7 < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/7.2.1/proj-7.2.1.tar.gz"
  sha256 "b384f42e5fb9c6d01fe5fa4d31da2e91329668863a684f97be5d4760dbbf0a14"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "ef50e257e02dadd349f715b576562fd1c3927e5ff52787bd3f8c7d85a41b8822"
    sha256 arm64_monterey: "29f65a3b916e6b967c157713b7a00daf1b91c01092628c292451ff5ade277ecf"
    sha256 arm64_big_sur:  "de4c07c82bb48aaacce06186daaa95e975ec13d9c63978ec74e46d00e29c9b4e"
    sha256 ventura:        "2114192236f2f619801c99d24c870962dbb04bb09861ce384aacd64613f48314"
    sha256 monterey:       "4315a9c41f5f97d1fbf80cf011b23e901009d28536897aeb0b640e8324a379af"
    sha256 big_sur:        "85fe28900d71302e7a6a433cf97f6c2bbffd760578a731f502a3dbea2be02917"
    sha256 catalina:       "34dc4a8dda8470ec24951126171ac370232d215a4623e8c8b67161b52a875706"
    sha256 mojave:         "cfda390ef15a53e47786071d599ded6ecfb540c3c70ae0174135d50c481f058b"
    sha256 x86_64_linux:   "00f08eda239998c9ecb8448a71320c8376ef03e0e02f27035b2628bcc61a74a6"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")
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
