class Flif < Formula
  desc "Free Loseless Image Format"
  homepage "https://flif.info/"
  url "https://github.com/FLIF-hub/FLIF/archive/v0.4.tar.gz"
  sha256 "cc98313ef0dbfef65d72bc21f730edf2a97a414f14bd73ad424368ce032fdb7f"
  license "LGPL-3.0-or-later"
  head "https://github.com/FLIF-hub/FLIF.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "398fe8152e8f752057a746c1369b9d8313ed3c7556c6e1011670ce2d4e060747"
    sha256 cellar: :any,                 arm64_monterey: "20c8b44c6ce76226aa53c3dc217bfe4ed82e7f181fb6122df515bf86e4e434f9"
    sha256 cellar: :any,                 arm64_big_sur:  "3d0d4c63012d30413c24e8b5e16829801d53887da55766e8143bbcc837875303"
    sha256 cellar: :any,                 ventura:        "601d0af71a74a364161912f8104787690e75e69fde57c8c82fab073570e478ea"
    sha256 cellar: :any,                 monterey:       "dfb3655e7c80bec23170595b2188ad897fd2e0e69af28711e6734f25b3c0db4e"
    sha256 cellar: :any,                 big_sur:        "41d2cd255724005a767991ab0bf3b7ae5f8ad9767a1413c9efa92bf6ba47af9f"
    sha256 cellar: :any,                 catalina:       "e757a4df0939f225afceae1b632542b9689f3fc9fcee7cf0364e463c1be778bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c76e5794a775d5d5d8b0dc8c92960ffdf5641b302132279a1a57a67e3e41550"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "sdl2"

  resource "homebrew-test_c" do
    url "https://raw.githubusercontent.com/FLIF-hub/FLIF/dcc2011/tools/test.c"
    sha256 "a20b625ba0efdb09ad21a8c1c9844f686f636656f0e9bd6c24ad441375223afe"
  end

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    doc.install "doc/flif.pdf"
  end

  test do
    testpath.install resource("homebrew-test_c")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lflif", "-o", "test"
    system "./test", "dummy.flif"
    system bin/"flif", "-i", "dummy.flif"
    system bin/"flif", "-I", test_fixtures("test.png"), "test.flif"
    system bin/"flif", "-d", "test.flif", "test.png"
    assert_predicate testpath/"test.png", :exist?, "Failed to decode test.flif"
  end
end
