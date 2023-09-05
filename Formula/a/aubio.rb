class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://github.com/aubio/aubio"
  url "http://sources.buildroot.net/aubio/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "1eee72e6668994865c26b6e3ae4cdde3dd8c275448e5940c36b251db5cc66bc1"
    sha256 cellar: :any,                 arm64_monterey: "f61587af7daa4baca8780ffc61dcc4cc72f03d0a9d0567f7153d27960746f28b"
    sha256 cellar: :any,                 arm64_big_sur:  "aa410dbe37a4beb13ad47982da915eb678f621090cb6cf2c96c5e36b534a3bb7"
    sha256 cellar: :any,                 ventura:        "32087ed3e3f47b5a1b7d38efc99f91b215eafb28dd989bdbca98dbdd45f75939"
    sha256 cellar: :any,                 monterey:       "86ec0b11858d37483abeac3750d7af632dd2b719f8043cdd6341c6654e4290d3"
    sha256 cellar: :any,                 big_sur:        "7e012835534713c23613399d0e92fdafa1736f584d877e3952b5c128e3d7792c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e37dbcb7d229175fc7aeee247c94bcedd30fd02d61d0ee5a3a60aca35b54dc6c"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "python@3.11"

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

    system python3, "-m", "pip", "install", *std_pip_args, "."
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
