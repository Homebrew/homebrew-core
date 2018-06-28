class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20180622.tar.gz"
  sha256 "e9f79509f44aac82c9663381f8f4bfb18a9a3c3eb112d418c92629a871bbb13c"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e669f4b26744a0db45b229d32cef5e0a83b505f36951f29dc29d881432ab924d" => :high_sierra
    sha256 "6e886f3d1dc610b74348c58bc90d8eb4c974a05a57a2ca4da8a654b070648645" => :sierra
    sha256 "64f1cebb8bc9ae33f011e800be57b9b69b1ef32a9ecc29661704f5e93a6a11bc" => :el_capitan
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
