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
    rebuild 1
    sha256 arm64_sequoia: "cdd72e2e045a52832a9050ce2695b6f922813854df1dd410c38c7ed8d0b94882"
    sha256 arm64_sonoma:  "0b3b530218db7a25081e82bdf9c235d9bd57ec656a1d4c9a1abc028c907c2eb9"
    sha256 arm64_ventura: "a05d35bae538b86c68e4712bb7b86212083fe5cac88189bbd3248ae7c189dbad"
    sha256 sonoma:        "843089029aa243aa70475e2a268378c3d90c427fa6f0e8227ce01f90ce510543"
    sha256 ventura:       "2cc8e8d50e223e7f42509148a31cb3684c64fd3941544d395229ecb2fffc83a6"
    sha256 arm64_linux:   "c32187d4a3dcd0a28643973ec32b14971a328393f5568303adfbc0898435ae8d"
    sha256 x86_64_linux:  "c4fd40654cf66d58978c3aea90360c621bfb758aaa8eb94adaa187f9cee4583a"
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "python@3.13"

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
    "python3.13"
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
