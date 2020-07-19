class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20200331.tar.gz"
  sha256 "d057f3dbfb0ec9474695075725bc09e28f1d1e021f5fe71c22903ed8cc18f7cb"
  license "BSD-3-Clause"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6087edcd6fc5bd534295bbb5d909764b0f83ecc50812e58923a8200a22f3b65" => :catalina
    sha256 "bd5449e4418187c4882e2b32afa857632dd8119f2583f5741272f74d65d82603" => :mojave
    sha256 "072d6b24939de3dd5202142398083a4e9759c7adfc2c34d323b4b76fcecb542f" => :high_sierra
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
