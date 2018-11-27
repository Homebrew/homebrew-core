class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20181125.tar.gz"
  sha256 "7b17a1333423b383deb2235685390fb0f30495262eb7d0aed293c32cf669936c"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88007ff3d589db9d0d1bf279fdd5b4615832fb4705658d64ec75ba8392253276" => :mojave
    sha256 "abacf45887c15b756f296ae821978290ec707a76982a8ea3be0088e2147ea0a1" => :high_sierra
    sha256 "5a3b32eeef358216b95b6606dbd270f6393f3762372f185d3d5a778ad3e9d98d" => :sierra
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
