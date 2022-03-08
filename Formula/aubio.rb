class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 2

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1042328e9b10eaa62a59bc41675f72274ca60eb8cf324cd118aaf32b2f4e85af"
    sha256 cellar: :any, arm64_big_sur:  "f6db53233e1b2855491b4b9310a579e4ac51c3dab7ac426f5c1c64b2fc0820f0"
    sha256 cellar: :any, monterey:       "90c6f81ecc23cf88ef8a800b6fefd8487dcdb6f9606e427b5fbfebe678b8a2fb"
    sha256 cellar: :any, big_sur:        "53bc8066ab50f4e4c24aad5f31e96f1ce0abac84930e5fcce43fa8f6083a878e"
    sha256 cellar: :any, catalina:       "9b24159cf4c8adbb1a78c5cab192453ebebd47260612d38005683ff093250b45"
    sha256 cellar: :any, mojave:         "653f41a951b87cf01049ed6a7019a3d2c96e635fc16d3be4d5edf3225b0a5f52"
    sha256 cellar: :any, high_sierra:    "d6cc3ba3c3a257f4d5b4c1c3a9c0c8cca4fccf09ffc682901888d26c039886a8"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python@3.9"

  resource "aiff" do
    url "http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/AIFF/Samples/CCRMA/wood24.aiff"
    sha256 "a87279e3a101162f6ab0d4f70df78594d613e16b80e6257cf19c5fc957a375f9"
  end

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    # Ensure `python` references use our python3
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    testpath.install resource("aiff")
    system bin/"aubiocut", "--verbose", "wood24.aiff"
    system bin/"aubioonset", "--verbose", "wood24.aiff"
  end
end
