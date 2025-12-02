class Dcm2niix < Formula
  desc "DICOM to NIfTI converter"
  homepage "https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage"
  url "https://github.com/rordenlab/dcm2niix/archive/refs/tags/v1.0.20250506.tar.gz"
  sha256 "1b24658678b6c24141e58760dbea9fe2786ffdd736bcc37a36d9cdabc731bafa"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/rordenlab/dcm2niix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "887894cb6a9d368dcb707572a92a3fedbc7f274b2f5b4308b1a6dffbb9e661ad"
    sha256                               arm64_sequoia: "cc953772d891f078f91fd15f340853dfba970634f20e22165987259f607b7155"
    sha256                               arm64_sonoma:  "ca821734148aff6d0baebd8c83c68f2fc20f26ac06e7b3351344fed94a8e4e39"
    sha256                               arm64_ventura: "260b608922b27a33915650bc66b36fd0aaa4415f139f09a5402877484cd60f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a28ea73ffecf684bbc7d96d7ad551927c1cfc334f57f294708e04edaa422ea"
    sha256 cellar: :any_skip_relocation, ventura:       "ac1a9f60a17fedba7485333d8992fa1bac206d6083e6cc23ba8e70b3db7e950f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71555b10ff6f721b9ab11c482a6d8d0385987d34cebd7d19186e70fcc43fa903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d28346e349db8dd0a7cdb4b08242e52f79ca6c6a5214aa7a6987cb3142e870e"
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
