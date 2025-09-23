class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/8c/9e/b4772f3c942a00a1ea7cce8055958e503292d314bff51feda1429a271f7a/dvr_scan-1.7.tar.gz"
  version "1.7.0.1"
  sha256 "f7036f8e679cd14bb61417266b1f8cff4f365a00227bff3d6ed75200f33e5c53"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6939c68d80fd38b540ebfdd2a513c8f617139186d1c4f0c0bcb949e4407e272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99cf90f97275ed4f15c0df16e89b0a76aba05eff89d663590706e25c872c73ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "db13e965368275d45493590b9190ece8b8b3fa5b44def90c09e80464cf73c39d"
    sha256 cellar: :any_skip_relocation, ventura:       "21fc1c751146e9262683b5788088da87d140060d465b32697ef39e62f15a493f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68e2e01e1fb8692745806ba12158535eec85f95022b0bdbed80632dae544b92"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.13"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/18/40/7b17cd866158238db704965da1b5849af261dbad393ea3ac966f934b2d39/cython-3.1.2.tar.gz"
    sha256 "6bbf7a953fa6762dfecdec015e3b054ba51c0121a45ad851fa130f63f5331381"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/e8/e9/0b85c81e2b441267bca707b5d89f56c2f02578ef8f3eafddf0e0c0b8848c/pyobjc_core-11.1.tar.gz"
    sha256 "b63d4d90c5df7e762f34739b39cc55bc63dbcf9fb2fb3f2671e528488c7a87fe"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/4b/c5/7a866d24bc026f79239b74d05e2cf3088b03263da66d53d1b4cf5207f5ae/pyobjc_framework_cocoa-11.1.tar.gz"
    sha256 "87df76b9b73e7ca699a828ff112564b59251bb9bbe72e610e670a4dc9940d038"
  end

  resource "scenedetect" do
    url "https://files.pythonhosted.org/packages/59/36/1e29ac958e2d2b5e4365fb7de03f94a98b9949c46267e682bcfe22460812/scenedetect-0.6.6.tar.gz"
    sha256 "4b50946abca886bd623e7a304e30da197f0e7e69cd65d80115d551538261c35b"
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
