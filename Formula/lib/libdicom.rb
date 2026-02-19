class Libdicom < Formula
  desc "DICOM WSI read library"
  homepage "https://github.com/ImagingDataCommons/libdicom"
  url "https://github.com/ImagingDataCommons/libdicom/releases/download/v1.2.0/libdicom-1.2.0.tar.xz"
  sha256 "3b8c05ceb6bf667fed997f23b476dd32c3dc6380eee1998185c211d86a7b4918"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "edf1ef90081de45407247c6f2c62dfa5f25ec6e449c77fd817587e4e7947bdd5"
    sha256 cellar: :any,                 arm64_sequoia: "a0ebd3a3367d71d0334a7891bcfd592e2b3afb155ee06ef53147132dfcefd60e"
    sha256 cellar: :any,                 arm64_sonoma:  "f375601773df0c5094df266775394c93aa72f5b48fb05cf1fc05b5af5cc9c3af"
    sha256 cellar: :any,                 arm64_ventura: "878c5957cfd9c3a44b204f9917c2dcdde618abbab7038a7b60052d4c9a5ac504"
    sha256 cellar: :any,                 sonoma:        "070a0a036117b34c98f56cd86327d70572bbb0131df4b2b0c31d3c32d585009e"
    sha256 cellar: :any,                 ventura:       "24ecd6d69b3020110e55b0a6d70737dec2df074a9568b65b1c7bf5a5f7e5d381"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2123321b416caf06cb685ed6307a53ada4d8eace6429595d99a1249caf171f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12c2177e7519f1cd98ed1d88e227eeabdee7236532fa270b1a780b16a068020"
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
