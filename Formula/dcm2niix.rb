class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20171204.tar.gz"
  sha256 "9e87b32309c15001e2f90214f12f25c2027724e30e96ec8bf0e15cc6e8e0a31e"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ba220e19e6df19b3e5730f5e5c8d443aa8305b4428d07f4c8dcee956920c6a6" => :high_sierra
    sha256 "f1a4895a68921aea52a7203f54d20e87656bc65454db216810dcc878d69714cf" => :sierra
    sha256 "b274753cdc3fe8a29467216326c8ccfa834d1142b3bfaf96f837f80af7c3ef2f" => :el_capitan
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
