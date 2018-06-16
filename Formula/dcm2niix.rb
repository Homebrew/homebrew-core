class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20180614.tar.gz"
  sha256 "1332b808545b976cde727e699ead5941faf75a2b97d023297de1e26360894bdb"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "322c0945d61f2203d62b15a94155c7a34bf8925a578d0050fe19f934d68fbdcb" => :high_sierra
    sha256 "b2291464e381862c25d189e616fc53fc23c35fec509fb19a72bc5bc4c9bc9c96" => :sierra
    sha256 "214ba6a0a5728c2387da5a0b06b8820cf6b33ad31eac81982dfbac58efb4760b" => :el_capitan
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
