class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20190902.tar.gz"
  sha256 "d8d4ae5ab7325260d237abe9d98f09992cf7e74fcbe2fd642aaab3a78c325cc1"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e33ffcbca3ef8e250e0fc380501084d90ac925ce2a7cc3c0ee728838db5b2b8e" => :mojave
    sha256 "4a43d0bced2c0e5222734d88efefc35e8582d829677663899af63c67cf51ce4d" => :high_sierra
    sha256 "a7c586cb051e2875b79893177b7e21bcc6d6aa37270963e62bbf7cbab5a955f7" => :sierra
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
