class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20250505.tar.gz"
  sha256 "3750e719596d310798722468a763d90e6a5d9edb720d321ca233926a0a508e32"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aafa3077e9b091f3794393cb261df879354d5e601dc6de66247361900ad24f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00f4172fa0e74a4a8c962a0989276ccb3220cab7c694dba275ff98271c67af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6d093932363eee682d6875916944672fd2ba8393e14318e1a746c26f3933730"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e8f2faa36c8c6e262c2c00e7ae54a9c35c5e57061513fa25469d26ecabd32e"
    sha256 cellar: :any_skip_relocation, ventura:       "60b7dcddebdb73c35be26a2ebf73a928ed4135764637f24d6a2d44a56c99abfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4367a8327072a9769ec29464e996cbbe36cb97c50f53036816a410e1eeee8d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "130292490d094cd918bec552ec8460536699b0ff9c08e5ef5c5f271829d953f9"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-sample.dcm" do
      url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
      sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
    end

    resource("homebrew-sample.dcm").stage testpath
    system bin/"dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_path_exists testpath/"localizer_1.nii"
    assert_path_exists testpath/"localizer_1.json"
  end
end
