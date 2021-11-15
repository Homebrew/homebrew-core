class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.9.tar.gz"
  sha256 "9f053338752ec96a6b619718037767682c5fd58e2471c08f3740fdb070605bc0"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1a578cfffc741545e5b49370a58ffba93d573173c19d81a883b7b0960dc07b73"
    sha256 cellar: :any,                 monterey:      "98e6604c1a4b6d6634cd8fc3ab7a3440f19d50f946daae731bdae1b65a595e07"
    sha256 cellar: :any,                 big_sur:       "be87829332b36a812cdc929cefcc5d2fdc29d026f7b04fe9ab98d0fb1b17d1d5"
    sha256 cellar: :any,                 catalina:      "da3502b0e4aa8306e4cd46fe3df9a3e0851d5d9e2bfb7a2ca8fa41f23e0b06c0"
    sha256 cellar: :any,                 mojave:        "f91c71752cfb0d544dd70e5ef60ab40de2ca8f47a2ac0b648980220a180528e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796e64c3eefd7d603556f391fcc284eaddb7cda7d0c15fe73d36fc04304ca5ca"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "cmake", *std_cmake_args,
                    "-DENABLE_FFMPEG=OFF",
                    "-DENABLE_OPENCV=OFF",
                    "-DENABLE_OPENEXR=OFF",
                    "-DENABLE_X=OFF"
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
