class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20170923.tar.gz"
  sha256 "2c535866c56ea632286c694f85fb3670fbd271edcd31941a8d1a53c8a4d7036d"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4fce413de1f6b566e84207d0fd601daa88561d1b2c2c2a1a65fbe4569691c36" => :high_sierra
    sha256 "33048fdbd9670d53571a101c27388f24582673a3ce19d0eacbc5eef8212c773b" => :sierra
    sha256 "8d06455d69b2043840d20bfab628ea4ce6efbcb365aade5441824a2326bb1568" => :el_capitan
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
