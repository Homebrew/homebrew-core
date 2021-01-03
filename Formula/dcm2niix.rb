class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20201102.tar.gz"
  sha256 "61afc206b2d8aca4351e181f43410eb35d3d437ea42c9f27c635732fe7869c8f"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b81e653813d4e2aff0579c29200e8e93bd71bb556b9a7336beed41094c9ba7ca" => :big_sur
    sha256 "c412eac15997e2d7f997f494281d230507860b56415abde2831a307dc57ae0ea" => :catalina
    sha256 "e94f102934799646ac65dd626b60659b8212721008cf37bc5d85b0b1df98f9f9" => :mojave
  end

  depends_on "cmake" => :build

  resource "sample.dcm" do
    url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
    sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("sample.dcm").stage testpath
    system "#{bin}/dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_predicate testpath/"localizer_1.nii", :exist?
    assert_predicate testpath/"localizer_1.json", :exist?
  end
end
