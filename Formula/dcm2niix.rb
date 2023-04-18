class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/v1.0.20220720.tar.gz"
  sha256 "a095545d6d70c5ce2efd90dcd58aebe536f135410c12165a9f231532ddab8991"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "657f60237a85e594706e0794278eb90dec747759fb42ddf9a31d27d9a81a22ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256379b33e4ee7fd98c343830fd473dffed638a434adfb44b82da00312ad7590"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb06fe151b7302db9b217653395041b83d5ba52f78c3482f8db2c7b0fa90e8a2"
    sha256 cellar: :any_skip_relocation, ventura:        "5bd79483fb9abd61dd04f6ef0b6bbdcbd982cae4ea69d4150e9f361a40906fb1"
    sha256 cellar: :any_skip_relocation, monterey:       "c23e27972dc9bcae0eb01a0452facd60f8d61a3389ee93fe30d627b31157a104"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e4dd1ee7e3fffb35945119ebda76e9756456e8ffa1f4bba32f1291f019472cd"
    sha256 cellar: :any_skip_relocation, catalina:       "b1efadda2cc14cd0ba5d995c1026f83139105da4deaaa7eadd9351494ddeee83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a34aabf5974cd3143c6440bd76610ee7f2d6bf52fe5d18c43735cb96fbc026a6"
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
