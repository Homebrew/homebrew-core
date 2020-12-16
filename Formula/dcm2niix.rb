class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20201102.tar.gz"
  sha256 "61afc206b2d8aca4351e181f43410eb35d3d437ea42c9f27c635732fe7869c8f"
  license "BSD-3-Clause"
  head "https://github.com/rordenlab/dcm2niix.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "96b3f0380b59bf996f128abd0a1672bbe4cd57988b17792a487dd8c7e76f7a33" => :big_sur
    sha256 "ca428fd8c6e95d016ac167aab146c966836325c65e1d4492438bbc4cdf6e0d5a" => :catalina
    sha256 "fb62cb684dc4b7a9314685080b51c2e9c4aa4fcaa620fbfa870bf0523d3fa944" => :mojave
    sha256 "677c116f759f36c0eca3dce1a2e109ec3f01c4789ceb5963b8aed41eb3b38803" => :high_sierra
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
