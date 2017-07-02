class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20170624.tar.gz"
  sha256 "802acfc99b2000c0222b8f3d03be5622033c407a67e77deda52997c673ba9c1e"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7761bca4948f64e5acc95d39a269598058595b2991be1d81d1eb128d0e23a73f" => :sierra
    sha256 "4cdcd4cc40138a073125da27a57fc54b8f9614c88efcc2bdf118140e0a92f9f5" => :el_capitan
    sha256 "fc0d48e20598d26b0906bfa2ccb9c61f5d513af9b5eb5ccc7c6243aef0940cff" => :yosemite
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
    assert File.exist? "localizer_1.nii"
    assert File.exist? "localizer_1.json"
  end
end
