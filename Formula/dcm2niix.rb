class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20180622.tar.gz"
  sha256 "e9f79509f44aac82c9663381f8f4bfb18a9a3c3eb112d418c92629a871bbb13c"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65fafbae23a6787c1da664d3bc01961dbd77cac42ff232406ba2fcb5547d6f11" => :mojave
    sha256 "ee9bf7bc4bf9f81335bb13575f6671ac04892c4ed5f07e88d28b4cb59a3b37da" => :high_sierra
    sha256 "9f1427167cc5ee01f2c8b4a1a940d1e41b3066be79b263d513ed90df816e4c4d" => :sierra
    sha256 "d0d9024e298b58e40d35ed147ec1a057f40d755751fe0c1494709903d5bef04c" => :el_capitan
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
