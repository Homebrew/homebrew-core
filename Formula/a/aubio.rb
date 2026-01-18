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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "54adb27d46e507c9fa6dd57b9da19b11fc435dc706d1a79a2835e83137813a05"
    sha256 arm64_sequoia: "c428580f0615808cafca003cc2596a913162586af33f5fd1235b274b413c3ed4"
    sha256 arm64_sonoma:  "979cea612bed708e02710af48d438df7f48a28ed502fb714d023182c24caf43c"
    sha256 sonoma:        "9200348f9f11f4149f91d7163e79f141f9bb7d2271a6af5398dc38ceadfd6ebd"
    sha256 arm64_linux:   "d98aea68e9a3677405a41ff89820d6ee76b5fb6fa7f02d964846c7b674756d06"
    sha256 x86_64_linux:  "be4fcc0b0a52320a3787a70cf2ba81bb1ba0e374921c7be49a96e0dc92d07feb"
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "python@3.14"

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
    "python3.14"
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
    resource "homebrew-aiff" do
      url "https://archive.org/download/TestAifAiffFile/02DayIsDone.aif"
      sha256 "bca81e8d13f3f6526cd54110ec1196afd5bda6c93b16a7ba5023e474901e050d"
    end

    testpath.install resource("homebrew-aiff")
    system bin/"aubiocut", "--verbose", "02DayIsDone.aif"
    system bin/"aubioonset", "--verbose", "02DayIsDone.aif"

    (testpath/"test.py").write <<~PYTHON
      import aubio
      src = aubio.source('#{testpath}/02DayIsDone.aif')
      total_frames = 0
      while True:
        samples, read = src()
        total_frames += read
        if read < src.hop_size:
          break
      print(total_frames)
    PYTHON
    assert_equal "8680056", shell_output("#{python3} test.py").chomp
  end
end
