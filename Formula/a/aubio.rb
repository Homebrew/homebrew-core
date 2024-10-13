class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://github.com/aubio/aubio"
  url "https://sources.buildroot.net/aubio/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "cfd2854886939bf7e0ed2a8a1bae86903f52b039cab6cba3dc8cdf8e0a6ed873"
    sha256 arm64_sonoma:   "861126445e0643c4135a942e9d95b858597ee35acae313a66248e434477820b9"
    sha256 arm64_ventura:  "68979803b19d987f8e6c007e5f0f8d15a5d2e40783d0f8b1f2df811d1850d989"
    sha256 arm64_monterey: "e7eab620a5f855dd1a3ed279451fa58e53c6efc186a597131c81d9d73acaa3e5"
    sha256 sonoma:         "a8bd9ab89e05ff75426654fdd70aefd450d2e1f06fe18cbd310f5414545dc8db"
    sha256 ventura:        "58d468192fe8cdf5173844cbcd80c21be7d389b4f3d323f15f1e3c0069e9d846"
    sha256 monterey:       "19f2f3c166e37236cd7721d8aede9c297d00955999e8942497b8f2bf57d51bf9"
    sha256 x86_64_linux:   "b9e34e9f4405c12be3a4e42305916c3399fcab7c1ddbf8e712cd379f06af763e"
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
    # Work-around for build issue with Xcode 15.3: https://github.com/aubio/aubio/issues/402
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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
