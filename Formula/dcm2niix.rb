class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20170923.tar.gz"
  sha256 "2c535866c56ea632286c694f85fb3670fbd271edcd31941a8d1a53c8a4d7036d"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "719d8190be594be864a72f8d3c9dd33c7e78a5c7cd05da95f0863638b4100e61" => :high_sierra
    sha256 "9318425b5251ffb036cc08566761a18652f95ae67240799e22d77a64faa8d2af" => :sierra
    sha256 "7635ff296978217fd64012ebce857b3dada4cb544fdca4fff04188ee03212f3a" => :el_capitan
    sha256 "a4eda9813749445a3ce4db31d6d37ae10c564d8b56847b67ea6c44b834827190" => :yosemite
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
