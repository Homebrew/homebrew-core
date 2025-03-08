class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://github.com/Breakthrough/DVR-Scan/archive/refs/tags/v1.7-release.tar.gz"
  sha256 "7e1d291df6184dab8fbd79e2639c90f8b2fe4f8c5c73265ed39f03f79b3167dd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83911a64fc655e2326960f5f9c7e5a0606c706d73ebd2cb909e7473d3bcdcddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2d29d7f050b083386ec3e363fbc134ef02d8579498577b57d7edecb2c145e41"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac79911dd503f51e7e6e33987e5e4a8e791aa16f603743a133b3772c98c5579"
    sha256 cellar: :any_skip_relocation, ventura:       "d01411ccdb13c2b34d99b5b35ed27ab316c771e0b94a4b2f575202a7701a515e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa475bd319341a32720e2589256ae7a76390640e25eec4b6cf01bcb88273343"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.13"

  on_macos do
    resource "pyobjc-core" do
      url "https://files.pythonhosted.org/packages/5d/07/2b3d63c0349fe4cf34d787a52a22faa156225808db2d1531fe58fabd779d/pyobjc_core-10.3.2.tar.gz"
      sha256 "dbf1475d864ce594288ce03e94e3a98dc7f0e4639971eb1e312bdf6661c21e0e"
    end

    resource "pyobjc-framework-cocoa" do
      url "https://files.pythonhosted.org/packages/39/41/4f09a5e9a6769b4dafb293ea597ed693cc0def0e07867ad0a42664f530b6/pyobjc_framework_cocoa-10.3.2.tar.gz"
      sha256 "673968e5435845bef969bfe374f31a1a6dc660c98608d2b84d5cae6eafa5c39d"
    end
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "scenedetect" do
    url "https://files.pythonhosted.org/packages/ef/4e/2f20c616b3dc8420dcc456fd1a0efee35e34f3e499843e22a2661e11f73d/scenedetect-0.6.5.2.tar.gz"
    sha256 "cf1af517409ac7b98905d8962de4fbefad01684355d12b5ccb992cbc6c4f8a52"
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

    virtualenv_install_with_resources
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
