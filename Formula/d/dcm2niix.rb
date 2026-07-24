class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20260724.tar.gz"
  sha256 "be6478b15aaf1e0c396df242e272a6a695966dc916672f519844ad1682b59e59"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "d3ff87c2e6393166c0536401079bfd18fdfb1436547447b13431cf2a5bcc2c07"
    sha256                               arm64_sequoia: "ac3d792c8cbdd089dd85d36efede1090887de3cdcaf3add259d177455c2309a5"
    sha256                               arm64_sonoma:  "6b8691bda9934782f77d92077ed07bdb1a7b49326ca9e0160463b02d79e2ee7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b1091d236d5f4baf51584e3e5695d1b1aa4b0bbc9078ced2960a22dbbbfddb"
    sha256 cellar: :any,                 arm64_linux:   "47237fc0c50250d6e27d3599e2cbd25ee3b304513cc1d05b6cf16c13a4fb2960"
    sha256 cellar: :any,                 x86_64_linux:  "ee4ffc4a6506f8f282ecc80bcba219dfb8479c54bcdfc1bd5b97a56ef287ae9b"
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
