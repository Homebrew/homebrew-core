class Libdicom < Formula
  desc "DICOM WSI read library"
  homepage "https://github.com/ImagingDataCommons/libdicom"
  url "https://github.com/ImagingDataCommons/libdicom/releases/download/v1.3.0/libdicom-1.3.0.tar.xz"
  sha256 "75f1167f5153c659cdd58f2b432d2592bf0477abe0087e195bc621b5594ef10a"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c79eab7fd6a8172a56e70bc79ae146e61ce972dae33a4f96a241cfbc350aa80"
    sha256 cellar: :any, arm64_sequoia: "bfd30b76fbad43ca1d1b9e2a7495d6e3f3fc4db0fd2bc5dbf329b7fe30a8cab5"
    sha256 cellar: :any, arm64_sonoma:  "55b41d87132d9ea42038fcfb8f21c6d32c60af94cad291e425384f229f632347"
    sha256 cellar: :any, sonoma:        "823c0d5d29e8de0dc7d121bdcc101c8e075e40cf5f08468944efde504b0dc843"
    sha256 cellar: :any, arm64_linux:   "c1055732177b2605ac2b7e152baf6f34a6f3bbca97ab97bdad0af3dedfbd55dc"
    sha256 cellar: :any, x86_64_linux:  "436e5320b8cfa3712e428943cdf5f7a8dc26386a470d7ad9b4da733b4b1b6925"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "uthash"

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-sample.dcm" do
      url "https://raw.githubusercontent.com/dangom/sample-dicom/master/MR000000.dcm"
      sha256 "4efd3edd2f5eeec2f655865c7aed9bc552308eb2bc681f5dd311b480f26f3567"
    end
    testpath.install resource("homebrew-sample.dcm")

    assert_match "File Meta Information", shell_output("#{bin}/dcm-dump #{testpath}/MR000000.dcm")

    assert_match version.to_s, shell_output("#{bin}/dcm-getframe -v")
  end
end
