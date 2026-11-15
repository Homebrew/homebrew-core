class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20261029.tar.gz"
  sha256 "be5d1a54604672110ec090fdb3a47904f8e742bbf0dbe193ccff85d33af3c5b7"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_golden_gate: "c5b65c52c4dd87e1b2dbc0124e650fe1f1f427c1d834015a6777cdf5bc5633b5"
    sha256               arm64_tahoe:       "8827a52a7d153b0ec2634a2a3d5891beacd07660a67f86d2de3ff02d977869c7"
    sha256               arm64_sequoia:     "722cee2357b69e76e5dab8dcc09873e3298d7ac988927101c591e0ed691bbf80"
    sha256 cellar: :any, arm64_linux:       "e5f34de692b3f2b60f6164058cdd691471dcaba10ee4818bb56a31fc8af3d65c"
    sha256 cellar: :any, x86_64_linux:      "ce2ab3dd40e9835f743f2b68d1f80de77380bba8fb5fe201c661336b489efcf3"
  end

  depends_on "cmake" => :build

  resource "homebrew-sample.dcm", :test do
    url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
    sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
  end

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-sample.dcm").stage testpath
    system bin/"dcm2niix", "-f", "%d_%e", "-z", "n", "-b", "y", testpath
    assert_path_exists testpath/"localizer_1.nii"
    assert_path_exists testpath/"localizer_1.json"
  end
end
