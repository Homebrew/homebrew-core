class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20240202.tar.gz"
  sha256 "ad8e4a5b97a682c32ef1d88283c15c7cb767c4092cb1754119f8e8b3d940fe91"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "150c1a7727e7f520b84ad40598a2e06b7d637f7976fd29a5c7958a50dbb4bde7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f15f3bcddae629bf3491a9aa564e2746c80102b81452e427d331d58459a41e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8faddf2f767f588c92f49feb4596387ad9d0fb2cb4dd59ceb3d684374205c8b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02cc2718e8b43c5061208ea668c85eeb9a72167c7b3a23e2016414161d7b0acf"
    sha256 cellar: :any_skip_relocation, sonoma:         "3714a3a18984472f62c78c885323c777775aa9e4a4a17a6d1b4e5c6d416b3a81"
    sha256 cellar: :any_skip_relocation, ventura:        "b028f4cadcab9918740eef012b378a77b750f5740dcff58c00e6747cb086d97d"
    sha256 cellar: :any_skip_relocation, monterey:       "c0475c59a38f6636c09d25423a7b9eac147d582adb67d46af93e2df805b62f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7618a1d4f9ae299c160ac51c8577e06a40112c858fe7d1abd9c17fb4d556db73"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-sample.dcm" do
      url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
      sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
    end

    resource("homebrew-sample.dcm").stage testpath
    system bin/"dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_predicate testpath/"localizer_1.nii", :exist?
    assert_predicate testpath/"localizer_1.json", :exist?
  end
end
