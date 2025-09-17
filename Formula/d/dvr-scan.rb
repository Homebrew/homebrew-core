class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/d5/21/1076956f89acea7b040d14ed6178e42d03b83b41e1954d4156a18df80333/dvr_scan-1.8.1.tar.gz"
  sha256 "3ac0c94e68f23cdd73f6433a9a3102e00b0409c5c4e6c654fc69650c719fa3c7"
  license "BSD-2-Clause"
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee8ae5bc7ff402c690a94b738bf97f53cf1c60509740196eebd06efa98526a38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f241fb1c8e811c48f6fb77b6480bbb3887fc68e3f7a0caf87c55a4e0ccbd3caf"
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
  depends_on "pillow"
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a7/f6/d762df1f436a0618455d37f4e4c4872a7cd0dcfc8dec3022ee99e4389c69/cython-3.1.4.tar.gz"
    sha256 "9aefefe831331e2d66ab31799814eae4d0f8a2d246cbaaaa14d1be29ef777683"
  end

  resource "opencv-contrib-python" do
    url "https://files.pythonhosted.org/packages/e0/b4/30fb53c33da02626b66dd40ad58dd4aa01eef834e422e098dfc056ed0873/opencv-contrib-python-4.12.0.88.tar.gz"
    sha256 "0f1e22823aace09067b9a0e8e2b4ba6d7a1ef08807d6cebea315f3133f419a0e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
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
    url "https://files.pythonhosted.org/packages/bd/b1/800d4c1d4da24cd673b921c0b5ffd5bbdcaa2a7f4f4dd86dd2c202a673c6/scenedetect-0.6.7.tar.gz"
    sha256 "1a2c73b57de2e1656f7896edc8523de7217f361179a8966e947f79d33e40830f"
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
