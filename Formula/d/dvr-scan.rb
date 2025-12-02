class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/8c/9e/b4772f3c942a00a1ea7cce8055958e503292d314bff51feda1429a271f7a/dvr_scan-1.7.tar.gz"
  version "1.7.0.1"
  sha256 "f7036f8e679cd14bb61417266b1f8cff4f365a00227bff3d6ed75200f33e5c53"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec1848f4c88957fcc74e970674d1d7291346d54514683961368af30db3a95451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c851d508df6be4bcb569dd5111d6c5e5908bcda43ae52ddcb28e9d1bb9bf1b58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f70c09cdebe43e4adbbc50901556d05dc899bf214205cb51555a9aeaa43794"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bcad6f56a72c1e0b0274bd6fa89cde2f13008ebdc274f5bf951fff7bf268c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b86ef516ae043d0a12206bac175ef23317e7bc92de1072af282abfe28941398a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63eeafe93e306fbee7c5d22e7391749db37e4f25e734efe98905a7bdc0175846"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  pypi_packages exclude_packages: "numpy",
                extra_packages:   "pyobjc-framework-cocoa"

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/83/36/cce2972e13e83ffe58bc73bfd9d37340b5e5113e8243841a57511c7ae1c2/cython-3.2.1.tar.gz"
    sha256 "2be1e4d0cbdf7f4cd4d9b8284a034e1989b59fd060f6bd4d24bf3729394d2ed8"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "scenedetect" do
    url "https://files.pythonhosted.org/packages/f0/b4/e77e1812ae89bc4864ff54efb6a8232eabebd471e372096cb711f03cca52/scenedetect-0.6.7.1.tar.gz"
    sha256 "07833b0cb83a0106786a88136462580e9865e097f411f01501a688714c483a4e"
  end

  resource "screeninfo" do
    url "https://files.pythonhosted.org/packages/ec/bb/e69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27/screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  def install
    # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
    ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}" if OS.mac?
    # pyobjc-core uses "-fdisable-block-signature-string" introduced in clang 17
    ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1699

    without = %w[pyobjc-core pyobjc-framework-cocoa] unless OS.mac?
    virtualenv_install_with_resources without:
  end

  test do
    resource "sample-vid" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end
    resource("sample-vid").stage do
      assert_match "Detected 1 motion event", shell_output("#{bin}/dvr-scan -i sample-5s.mp4 2>&1")
    end
  end
end
