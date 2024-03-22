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
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "ab73e13683ffe8f16420f3840b812d526aaa5cd8c504db046016326bc82eaf90"
    sha256 cellar: :any,                 arm64_ventura:  "830a71f3bab206de19e3b1b7a60ceecfb85e1c5215c265f70efe1c0ad1bebfc5"
    sha256 cellar: :any,                 arm64_monterey: "5b25c1f944296cf89d576a90bd691381dc3030020b1d0845985803754b85936d"
    sha256 cellar: :any,                 sonoma:         "d7f0930c4d82642f232ed8db39018134251bc1abd32729c7feeb491ca41848e4"
    sha256 cellar: :any,                 ventura:        "c2b2d098bc08de758990f533bdd892615adeb3fc83c980b66500f9b5144e7cc3"
    sha256 cellar: :any,                 monterey:       "211264da83fe13e14a91869011e6fe79f1b63cb7110bd3d8f214178fe6b51def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80790bb2aefbfdbaf13ecfa873325f22ebbe7d5bf8bea8a921696ce91494ae89"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "python@3.12"

  resource "homebrew-aiff" do
    url "https://archive.org/download/TestAifAiffFile/02DayIsDone.aif"
    sha256 "bca81e8d13f3f6526cd54110ec1196afd5bda6c93b16a7ba5023e474901e050d"
  end

  # Fix build with Python 3.12 using Fedora patch. Failure is due to old waf 2.0.14.
  # Remove on next release as HEAD has newer waf.
  patch do
    url "https://src.fedoraproject.org/rpms/aubio/raw/29fb7e383b5465f4704b1cdc7db27df716e1b45c/f/aubio-python39.patch"
    sha256 "2f9cb8913b1c4840588df2f437f702c329b4de4e46eff4dcf68aff4b5024a358"
  end
  patch do
    url "https://src.fedoraproject.org/rpms/aubio/raw/454ac411d2af0ebcf63cdb1bacd8f229817c27c9/f/aubio-imp-removed.patch"
    sha256 "0ff5cbb3cdcebbced7432366c3eb0f742db48e864b48bf845c0d3240136c5cdb"
  end

  def python3
    "python3.12"
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
