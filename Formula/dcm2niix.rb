class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20180622.tar.gz"
  sha256 "e9f79509f44aac82c9663381f8f4bfb18a9a3c3eb112d418c92629a871bbb13c"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5b5a1e9415a26a6a2c3498fa5429b6aee6d5649c83631e38f85bb7dc43be1de3" => :mojave
    sha256 "bb31e0f11fe9de317ad16941ed65fc6e95ad9fef801e3f2f3662c3a79beea507" => :high_sierra
    sha256 "4d2b1e2091fdff610144ab37a27f9e0d2f5a426f69efae9c25283ed03805dccc" => :sierra
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
