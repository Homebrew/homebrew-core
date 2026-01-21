class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/36/a0/ebc12a29cbc069d7b7ac2144372f6f219d659854b2d04e06576597ccbeff/dvr_scan-1.8.2.tar.gz"
  sha256 "ec571e154ae845eeab9769d5c80e8b1ef007ef512a472a5269a02b6233ac2a72"
  license "BSD-2-Clause"
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "464bddf177aeb6c154631675e314162fc3e1462bc9deb38ae99ac8018a103429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8596755c7279f78f7fc5dd44e91ea2e5e214854ac0de87ccccc001a06d76d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0034c3ff1658001475f364ad63d700dee62e60b08b1b5f45b9688cf16307bb71"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d5d5db27b73844d6a4e972696e4fd0de5c243ba9777f3a5ecd4f7f50572a59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "641ec3e00a7615df22dc06d476fab1e8388e35fab29967818f3daff6e1807a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b02e8587351d6ae7e8b6b15698ec3d20129ba7f2f7c8490cd3fef86225030b8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "pillow"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  pypi_packages exclude_packages: %w[numpy opencv-contrib-python pillow],
                extra_packages:   "pyobjc-framework-cocoa"

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/91/85/7574c9cd44b69a27210444b6650f6477f56c75fee1b70d7672d3e4166167/cython-3.2.4.tar.gz"
    sha256 "84226ecd313b233da27dc2eb3601b4f222b8209c3a7216d8733b031da1dc64e6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
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
