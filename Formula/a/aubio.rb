class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org"
  url "https://sources.buildroot.net/aubio/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "93791777c67b8fa6cde559f3b799d9bb320b52f97a89b03a8c413aa9f708e05f"
    sha256 arm64_tahoe:       "a867233c8e0aba10ccf0ec1458c8068d69a5b9c0af0a207f088f75f01553182c"
    sha256 arm64_sequoia:     "b9bbe3be57a540aed82157cb8332378f589ee49ff8fee62d224c52e0668ff971"
    sha256 arm64_linux:       "9c19c33e1ca6b94072d02c167352e6cf4f5101b29b2eca4e3f01ab4b7bacac57"
    sha256 x86_64_linux:      "9d0fd367d58a6ddea8c8b4d7c32cc48e1b6593c2db63dfc5962f2e0d9dacf70d"
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "python@3.15"

  resource "homebrew-aiff", :test do
    url "https://archive.org/download/TestAifAiffFile/02DayIsDone.aif"
    sha256 "bca81e8d13f3f6526cd54110ec1196afd5bda6c93b16a7ba5023e474901e050d"
  end

  # Fix build with Python 3.12 using Fedora patch. Failure is due to old waf 2.0.14.
  # Remove on next release as HEAD has newer waf.
  patch do
    url "https://src.fedoraproject.org/rpms/aubio/raw/29fb7e383b5465f4704b1cdc7db27df716e1b45c/f/aubio-python39.patch"
    sha256 "2f9cb8913b1c4840588df2f437f702c329b4de4e46eff4dcf68aff4b5024a358"
    type :unofficial
  end
  patch do
    url "https://src.fedoraproject.org/rpms/aubio/raw/454ac411d2af0ebcf63cdb1bacd8f229817c27c9/f/aubio-imp-removed.patch"
    sha256 "0ff5cbb3cdcebbced7432366c3eb0f742db48e864b48bf845c0d3240136c5cdb"
    type :unofficial
  end

  def install
    # Work-around for build issue with Xcode 15.3: https://github.com/aubio/aubio/issues/402
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system python3, "./waf", "configure", "--prefix=#{prefix}", "--libdir=#{lib}"
    system python3, "./waf", "build"
    system python3, "./waf", "install"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
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
