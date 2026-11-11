class DvrScan < Formula
  include Language::Python::Virtualenv

  desc "Extract scenes with motion from videos"
  homepage "https://www.dvr-scan.com/"
  url "https://files.pythonhosted.org/packages/99/0c/adc2d879b29d557007191d30b4d573744a0f2c0e76f1cdfc426260b26c2c/dvr_scan-2.0.tar.gz"
  sha256 "f48f4365fff3dd56b84dde6d4e02e1164fe86462cd142cf522d4acfaea51672e"
  license "BSD-2-Clause"
  head "https://github.com/Breakthrough/DVR-Scan.git", branch: "main"

  no_autobump! because: "macOS resources cannot be updated on linux CI"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d6ee83a2a8a1d8a37688a1d8d793cefbe0d45e2ece7746c70a2e5b7698b4f896"
    sha256 cellar: :any, arm64_tahoe:       "54e3caa9c1c48e2470ae76829f8201ef75d88ea3f9f5608117c16fa178029fac"
    sha256 cellar: :any, arm64_sequoia:     "2f93ab1e508fb51ce760cae089650cc38abdf28f228302f0993ddf5dbf8a3db5"
    sha256 cellar: :any, arm64_linux:       "00e919ecf5b0cf24166d6574279bad22aa98de4a88d625343432079ea14f289b"
    sha256 cellar: :any, x86_64_linux:      "1ed188b46d2fc503bb950cc9a48f8eb5553c6376d434e8f9fccb71bb521a1bf9"
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

  pypi_packages exclude_packages: %w[numpy opencv-contrib-python opencv-python pillow tkinterdnd2],
                extra_packages:   "pyobjc-framework-cocoa"

  resource "av" do
    url "https://files.pythonhosted.org/packages/23/01/76b6bf563fe907597cf58f10d10168e93fe588b6db9f2658db87e87efa7e/av-19.0.2.tar.gz"
    sha256 "bebbc52598886480f4d861c575dc2b020785d6c04e1308680ddcc545e1b94c66"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/99/ca/18e324972e5cac914816fdd7bb03e19a455b90039c277a538f7781b50c85/cython-3.3.1.tar.gz"
    sha256 "e0e45989e821bef6aa9ae15c7d583ab5e055f7406c4b3624e49e06d24e90375a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
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
    url "https://files.pythonhosted.org/packages/10/8b/53ba2573a4daf9697d9e5c7892d10cfce0c189063ab4df7fd74286ee029d/scenedetect-0.7.3.tar.gz"
    sha256 "14c0bd6872fb4fd284817d77187f8164dc79ef403067840d5337660f3e9aa9fa"
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
      # https://github.com/Breakthrough/DVR-Scan/blob/v2.0-release/tests/test_cli.py#L46-L58
      output = shell_output("#{bin}/dvr-scan -i traffic_camera.mp4 -so -a 631 532 841 532 841 659 631 659 " \
                            "--min-event-length 4 --time-before-event 0 --threshold 0.2 --ignore-user-config")
      assert_match "Detected 3 motion events", output
    end
  end
end
