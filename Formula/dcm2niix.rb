class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20210317.tar.gz"
  sha256 "42fb22458ebfe44036c3d6145dacc6c1dc577ebbb067bedc190ed06f546ee05a"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3dbe411fc4732bd4a022d67b31476f49880ddc946a6fab1b39466b2c013d54d"
    sha256 cellar: :any_skip_relocation, big_sur:       "084829fb99291a81c2d1980c4bbfb1c22a43956ac912f4a47a1db23b1dff90b6"
    sha256 cellar: :any_skip_relocation, catalina:      "2583d8380bc1c50f2868cb490ce80505b297ef4258ff9256f892999a0b0b6b85"
    sha256 cellar: :any_skip_relocation, mojave:        "eab67d24efc13b483a7b9e988bf44efd49aa3e40e12c4deb682832ceae9b7286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc2a14a090a22072454dd9cb8003a723fee867fe6ef524cfb2e7741888a26f9"
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
