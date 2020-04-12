class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20200331.tar.gz"
  sha256 "d057f3dbfb0ec9474695075725bc09e28f1d1e021f5fe71c22903ed8cc18f7cb"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "465e82682ce5746f969850e416aafd695076684f478ce03c615df0b40fc12ec5" => :catalina
    sha256 "2120680975a3caf5e0453e7b233ac55cdfc2ea53bcfa4fde61cfbaf593c4b561" => :mojave
    sha256 "82d4070c7a29a0e38f5c183ea894d0e5491f38fab1eb5b32e3eb430ac92f42b8" => :high_sierra
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
