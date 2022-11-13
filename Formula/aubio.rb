class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://github.com/aubio/aubio"
  url "http://sources.buildroot.net/aubio/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 3

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a4511d273dd660c733a50e0368575fb71f21e1720fe35a3e40e0c02f61b20a7"
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
  depends_on "python@3.11"

  on_linux do
    depends_on "libsndfile"
  end

  resource "homebrew-aiff" do
    url "https://archive.org/download/TestAifAiffFile/02DayIsDone.aif"
    sha256 "bca81e8d13f3f6526cd54110ec1196afd5bda6c93b16a7ba5023e474901e050d"
  end

  # Fix build with Python 3.11 using Fedora patch. Failure is due to old waf 2.0.14.
  # Remove on next release as HEAD has newer waf.
  patch do
    url "https://src.fedoraproject.org/rpms/aubio/raw/29fb7e383b5465f4704b1cdc7db27df716e1b45c/f/aubio-python39.patch"
    sha256 "2f9cb8913b1c4840588df2f437f702c329b4de4e46eff4dcf68aff4b5024a358"
  end

  def python3
    "python3.11"
  end

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    system python3, "./waf", "configure", "--prefix=#{prefix}"
    system python3, "./waf", "build"
    system python3, "./waf", "install"

    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    testpath.install resource("homebrew-aiff")
    system bin/"aubiocut", "--verbose", "02DayIsDone.aif"
    system bin/"aubioonset", "--verbose", "02DayIsDone.aif"

    (testpath/"test.py").write <<~EOS
      import aubio
      src = aubio.source('#{testpath}/02DayIsDone.aif')
      total_frames = 0
      while True:
        samples, read = src()
        total_frames += read
        if read < src.hop_size:
          break
      print(total_frames)
    EOS
    assert_equal "8680056", shell_output("#{python3} test.py").chomp
  end
end
