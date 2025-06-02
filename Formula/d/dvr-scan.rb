class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://github.com/Breakthrough/DVR-Scan/archive/refs/tags/v1.7.0.1-release.tar.gz"
  sha256 "c0bdb1d1963a1df38d30ba6ded04bc37013b143c551360a177fdde4fe33e7fc9"
  license "BSD-2-Clause"

  # All release versions end with `-release` suffix
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "986102fcac41135a62884a15d909914ae48e9f2a5932164386800763dad551a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b3b52d9b93bfd31ab99d6cc94d335c4b06449aeb32dc2e592b629d76e658979"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8225c786db4e4b76944d871a97872d1f69cddc5dd81d6fb8e3458697f227a44"
    sha256 cellar: :any_skip_relocation, ventura:       "f9455478612e42c382db2216da511f8b680eb5304c4cfddd87ccb7698aec9949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeece253f4474e20ffa1b16386bf88b76b7cd0aa2862dfa83e1f88e4768a8b53"
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
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
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
