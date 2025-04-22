class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20241211.tar.gz"
  sha256 "3c7643ac6a1cd9517209eb06f430ad5e2b39583e6a35364f015e5ec3380f9ee2"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0b06a5b2894702dc46bc9f7de01dffc4287da7a94b1a586c2113d872b85c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b89aa18f86588bff4689bb3592493b2c299df30338cc8cc1ceefb2bc085be2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f848dbc3fcc8eb421c5a32fa0c159afe1601cf7111f95bb6cda721bd9e12d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c716538917b7ab79080a7b64647e2e7fb1312b6a622e3882c8ff084c944d70d"
    sha256 cellar: :any_skip_relocation, ventura:       "f30ff1f7cdba4bbee0e9dbc71cd8097c5f758a1d037de1e518281c4b8183223c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a10cbb413a652bd211a3bbc66ba8bbc002c4527b75a62537bd10d1797443563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13baad586219be6dd44afd6992c7cf33bacd2b51abdb819a713ed3a0658b7df3"
  end

  depends_on "cmake" => :build

  def install
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
