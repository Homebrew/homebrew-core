class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20180325.tar.gz"
  sha256 "a92289e08eed776b922e0c39fe206a8ea75ed8718660fb4ce9b7cf9bde0b3f5b"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f97fd716da0e8fc31d7bb7161b63affc2e738ee3117a7d90e507041f2f0f60ad" => :high_sierra
    sha256 "aa497ab3989b205680342cb2d61ef2323c52ca0b2ebcdddace2ebfd993308063" => :sierra
    sha256 "08645eff6be026861a24f468420557c54e53254097bf975c6d500a736999fed8" => :el_capitan
  end

  option "with-batch"

  depends_on "cmake" => :build

  resource "sample.dcm" do
    url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
    sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
  end

  def install
    args = std_cmake_args
    args << "-DBATCH_VERSION=ON" if build.with? "batch"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    resource("sample.dcm").stage testpath
    system "#{bin}/dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_predicate testpath/"localizer_1.nii", :exist?
    assert_predicate testpath/"localizer_1.json", :exist?
  end
end
