class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20170724.tar.gz"
  sha256 "90fbcf410324716e41056d94acb46ad93192af1479865b9299e4efe57cd5c2b7"
  head "https://github.com/rordenlab/dcm2niix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16151f67a12a03458f1cc1f5e9794ec01d50430dd29ac61ff357faee07c51223" => :sierra
    sha256 "9d3c88c2689f255fab4d89f3cbb369948684f875d214186489d6dc8b1ac70616" => :el_capitan
    sha256 "4a177fc2fb4fb59f1076b5518ec917df81a9a217a457e1d74e84260d8ca98c91" => :yosemite
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
    assert File.exist? "localizer_1.nii"
    assert File.exist? "localizer_1.json"
  end
end
