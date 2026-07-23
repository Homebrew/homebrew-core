class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20260416.tar.gz"
  sha256 "dc87a34b8284df2700a5aee433c4ba7ea56b999ac774fcf684962de5e898670d"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "6f1e01c9d3edee9470d14033c1a3b9f6c7bddc7474fc0f916949ce8e4c9dece2"
    sha256                               arm64_sequoia: "781e5f1d49c8e2811b60cdd71316a10813d1f9fee0637ea4614271e30667c712"
    sha256                               arm64_sonoma:  "8e78e0a91b0fa02bec640991fe6f07a3766c80bcb816a79b25dd6033f7fb18d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9bab3bc043ae32cb80aa7a64d9f668736b14eec546f529b2f3f8b73e7a52ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8903003d4c70a0973cace04352d99b7912d6f712421f7a06bc1d45f0f994d879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1694c2b47ee8fd650956909c9a46b252d146381d695d46f0fcf35938043443"
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
    assert_path_exists testpath/"localizer_1.nii"
    assert_path_exists testpath/"localizer_1.json"
  end
end
