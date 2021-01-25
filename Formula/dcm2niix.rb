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
    rebuild 1
    sha256 "c8aa22013787e0bf4a0d564a0fcd1d34db2ef483cc887d8333d5426aadaca1a4" => :big_sur
    sha256 "59d511d48dc49ff674c1183f34663125712c806db531e72ba3264bf436086104" => :catalina
    sha256 "3f90d3eea9e28a0b0e050a4a14cbe61372dc4ade311fc57d5de367f99e4ba1b1" => :mojave
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
