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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4417eae32550a60bdf8bc040dc1b0d6e3d368224c548c78555fd29021b17a91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b985d7e3d7cd0d6bf7b017d924ef09919d93256cba4142f0c5d87ed9c5bd2b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d272ee38eacaf36292a93d6c9705cfb3b0713a691a21c44476a70c101e34022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f7940a7b39c42c3cef65925e26c7168d4d67bfe8921149363340b156595ccd75"
    sha256 cellar: :any_skip_relocation, sonoma:            "9267191144d62a235c0a6c2e01cc4bb61389a9f6aae7051295052c4acb8ca77d"
    sha256 cellar: :any,                 arm64_linux:       "0958b7913a4500f9519a958ec0a11ff2ded19dd9776fd281683cf7068ce4b69e"
    sha256 cellar: :any,                 x86_64_linux:      "fa4334f8c940bdd4abf258a2ae39f597506901404b9e12760a638a0fac153875"
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
    url "https://files.pythonhosted.org/packages/da/91/4a03cfdb03314cfca262921797fff04ff4054bd86a160aed76eddf8aa12b/platformdirs-4.13.3.tar.gz"
    sha256 "5e567f664eb087ab8521c0179cd8d1bd60857d271136567a39719e28e2d383ce"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/a5/78/abc4ce5920305780aeb36b4067a86253378b36e29ba96673a3deb02eb03a/pyobjc_core-12.2.2.tar.gz"
    sha256 "3906452339cd06a3bb07df103c2511d4cb0f7a22d8771c0b802eba15d9a642b6"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/75/76/49c6da2c6a831020b4854ba20079d5a1030474bffc776b7b73c2eeff8c15/pyobjc_framework_cocoa-12.2.2.tar.gz"
    sha256 "c96c0ef69a71afbbb0e6a7d594b455c5fe47d62e0db376ee7a2b4b828c16ace9"
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
