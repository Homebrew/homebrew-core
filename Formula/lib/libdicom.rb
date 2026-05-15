class Libdicom < Formula
  desc "DICOM WSI read library"
  homepage "https://github.com/ImagingDataCommons/libdicom"
  url "https://github.com/ImagingDataCommons/libdicom/releases/download/v1.2.1/libdicom-1.2.1.tar.xz"
  sha256 "7a448d295b179a4c0b311c09f5253655446a44bf66b3b7d2aa4c09d15f02f1f8"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9a14120d4cfa52dd2071bbcb9d43523b712b43f19a06204ed6d6e87bb3b98d2"
    sha256 cellar: :any,                 arm64_sequoia: "03152b93d7e51c7e967a3d5774f6c5f4a487e6404c06ff79780da38fc6085bbe"
    sha256 cellar: :any,                 arm64_sonoma:  "6a70bf18be8cdab41295bcb8c702caaa02e41b10c40fcfda08698d86fa2a9e66"
    sha256 cellar: :any,                 sonoma:        "1005712c39f20e0ed08bd41f71e356928ce8900bda502a3440c10b67afe4f121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a013097c92ecc377e3001ef0ecf42d716d34b68af3adb8d4dc0b3854ef27e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940adb9a8ec118f961c3fba37a15b8594718895a5d12c485926632aea6b5613b"
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
