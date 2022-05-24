class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 3

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24480a57c922ecce159a8c51c7b6cbd888534ad071f8e6e44c2673d9af3cc123"
    sha256 cellar: :any,                 arm64_big_sur:  "1109fc08328664e84eff65a547737b1ac602e23519e6a88855fbd9a25a341a2c"
    sha256 cellar: :any,                 monterey:       "81bde2bc55939b498d263f6486f80f2c29b67ef6927db247ace8345ae34b2357"
    sha256 cellar: :any,                 big_sur:        "ce2477e78e0ddf5c3d2801c571c65e73a73a33967650aa067a94d49695a144d4"
    sha256 cellar: :any,                 catalina:       "3a0a2bcf355eef8bb66385c5bda82105569c2a7f999182626ca0b417d44e6255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741a3b0b3f1230f381b0ba5aef3815c8c6d1f437ccec04b95b70dad388cc0e33"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python@3.10"

  on_linux do
    depends_on "libsndfile"
  end

  resource "aiff" do
    url "http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/AIFF/Samples/CCRMA/wood24.aiff"
    sha256 "a87279e3a101162f6ab0d4f70df78594d613e16b80e6257cf19c5fc957a375f9"
  end

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    # Ensure `python` references use our python3
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    system "python3", *Language::Python.setup_install_args(prefix),
                      "--install-lib=#{prefix/Language::Python.site_packages("python3")}"
  end

  test do
    testpath.install resource("aiff")
    system bin/"aubiocut", "--verbose", "wood24.aiff"
    system bin/"aubioonset", "--verbose", "wood24.aiff"
  end
end
