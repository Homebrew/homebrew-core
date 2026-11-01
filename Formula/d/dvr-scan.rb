class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/47/84/a3256473a827f0c17e3e724c409a33146a26d6515f87df38c3a649547b7d/dvr_scan-1.8.2.1.tar.gz"
  sha256 "e424eaa8f2502a773588c97722bfe163f1317129e6e7073c25c4282bcf5f8e40"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  no_autobump! because: "macOS resources cannot be updated on linux CI"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f38c4470152c9254fbcc91002a0dab7aa25f7e13973fbd9d131e4746a31cb745"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b6f19ec5d092c0b7b0168766c3bd5b00187571f335da1af8de3921671ffdf90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87b5d31db9341083f53ef9202dcf5e0294f7576db6c5541fe66d5c08a402ec33"
    sha256 cellar: :any,                 arm64_linux:       "7611b01632af86dead773eec013697db382e5b09f326a3fa35d4578f2abd6e56"
    sha256 cellar: :any,                 x86_64_linux:      "eedaa11e3d0100cdef763d210645ef363907cf1147d16121c68b94c6cccc8dd5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "opencv"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "pyobjc-core uses `-fdisable-block-signature-string`"
  end

  pypi_packages exclude_packages: %w[numpy opencv-contrib-python pillow],
                extra_packages:   "pyobjc-framework-cocoa"

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/83/58/7bab095330b8893e1ac58f3cf9710462c3242b600f8fa5db0d5dda795775/pyobjc_core-13.0.tar.gz"
    sha256 "ffe154462d14aa4852f424e9116f17b5f8d44f78fc0f6c4727e721a5fa7177da"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/30/50/55a8779d35f1f86d795264cbd6fe62e35b2cf4fb8343fc888e99268c988a/pyobjc_framework_cocoa-13.0.tar.gz"
    sha256 "bb7a23941fc8d7866578dbc84e56140efd343a1d28510f530dd1dbf80807daf4"
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
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "sample-vid", :test do
    url "https://raw.githubusercontent.com/Breakthrough/DVR-Scan/6afbff4374e435ce40d51311084e96bf087bf7aa/tests/resources/traffic_camera.mp4"
    sha256 "cb8dd0170b28c6322b399d78464ff4515a32728b73c14de5e5c3729b98ce82aa"
  end

  def install
    # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
    ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}" if OS.mac?
    # Make `pyobjc-core` detect the SDK that superenv compiles with rather than the newer Xcode one
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    without = %w[pyobjc-core pyobjc-framework-cocoa] unless OS.mac?
    virtualenv_install_with_resources without:
  end

  test do
    resource("sample-vid").stage do
      # https://github.com/Breakthrough/DVR-Scan/blob/main/tests/resources/traffic_camera.txt
      output = shell_output("#{bin}/dvr-scan -i traffic_camera.mp4 -so -roi 631 532 210, 127")
      assert_match "Detected 3 motion events", output
    end
  end
end
