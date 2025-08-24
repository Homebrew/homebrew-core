class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/8b/03/843dc883fbb3ad6900b2f2aa1fd59b28c6af42eedb7d1a40917e40fec04b/dvr_scan-1.8.tar.gz"
  sha256 "21c013906f1f8213394dafff763be8d75fd7ce6482d9a5dd3dc5e27a0cf25caa"
  license "BSD-2-Clause"
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2aa5464002c26e0b4afe47e2b09dfcdbfd2a25422c3e98c232b8d7a8dfcd4aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70f057f3106aa1de405c48923ea9d8b2c225a72bf45d3f58cc58a3fe0c7a2851"
    sha256 cellar: :any_skip_relocation, sonoma:        "eea7a60068ab2dacd603c5f2ed9f96913006511e1fdd7a2482c2a69e67278f6c"
    sha256 cellar: :any_skip_relocation, ventura:       "5b1bd609001d48e7ba57651cb155476a83c69af8f770e1d2a6479101d0884345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948e7ef0ca0180ec176c543082969dcc247ecb3d6df91bf1b456f59a86478175"
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

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/18/ab/915337fb39ab4f4539a313df38fc69938df3bf14141b90d61dfd5c2919de/cython-3.1.3.tar.gz"
    sha256 "10ee785e42328924b78f75a74f66a813cb956b4a9bc91c44816d089d5934c089"
  end

  resource "opencv-contrib-python" do
    url "https://files.pythonhosted.org/packages/e0/b4/30fb53c33da02626b66dd40ad58dd4aa01eef834e422e098dfc056ed0873/opencv-contrib-python-4.12.0.88.tar.gz"
    sha256 "0f1e22823aace09067b9a0e8e2b4ba6d7a1ef08807d6cebea315f3133f419a0e"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/ac/71/25c98e634b6bdeca4727c7f6d6927b056080668c5008ad3c8fc9e7f8f6ec/opencv-python-4.12.0.88.tar.gz"
    sha256 "8b738389cede219405f6f3880b851efa3415ccd674752219377353f017d2994d"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/f3/0d/d0d6dea55cd152ce3d6767bb38a8fc10e33796ba4ba210cbab9354b6d238/pillow-11.3.0.tar.gz"
    sha256 "3828ee7586cd0b2091b6209e5ad53e20d0649bbe87164a459d0676e035e8f523"
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
