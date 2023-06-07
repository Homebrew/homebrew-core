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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "fc1d3b1aa92672e0c3e35b09bf6d85b7dba1b050ad2487b4b2b0e09c21c10043"
    sha256 cellar: :any,                 arm64_monterey: "e14563110ed6dec852f555c029950424f4be1df4528185c9157f472bce458134"
    sha256 cellar: :any,                 arm64_big_sur:  "4698b86e472c8dd33c2f3e89bfed39dff49b6da6d7bf507a920f0a9a0ddf89a9"
    sha256 cellar: :any,                 ventura:        "50b70b2039563f25e2db9d31537da6e1ea8fd43a31aa75a90faeccb8c939ce2f"
    sha256 cellar: :any,                 monterey:       "40cb324664af9b380697f41e56cd65d00d8d8b95a3fcc37fada0816716fba180"
    sha256 cellar: :any,                 big_sur:        "6e0ca22b336d5a080bf1507e9bf33e4ad6e92256cab6ea3d4c160f91fb2548d3"
    sha256 cellar: :any,                 catalina:       "4f0fb8e363ba83e36c1186a58f15f9b780d72d090915ceb0cf9a99756b209d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4c98bc548d77658141e6bc1075b250fa75755e687c7e6a43dd611b25dd2ef6"
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
