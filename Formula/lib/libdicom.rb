class Libdicom < Formula
  desc "DICOM WSI read library"
  homepage "https://github.com/ImagingDataCommons/libdicom"
  url "https://github.com/ImagingDataCommons/libdicom/releases/download/v1.0.5/libdicom-1.0.5.tar.xz"
  sha256 "3b88f267b58009005bc1182d8bd0c4a3218013ce202da722e5e8c9867c6f94f4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2450816778a6e5a0e43e1a6bb0a16b49e4c4e4a46821346e00a9867b52f135c"
    sha256 cellar: :any,                 arm64_ventura:  "b564c83d552c4f3a781922cfb03e4e73307d0953ab292daf16215fc02a20ce01"
    sha256 cellar: :any,                 arm64_monterey: "78e23077f174ca56bdc1daeeebcb267dc53f63c119e188d7c6a3f0468e82a8a4"
    sha256 cellar: :any,                 sonoma:         "8e035f6ffa891b48f2c558b70a2eded298950b7dd4b153edc720120bd883537b"
    sha256 cellar: :any,                 ventura:        "29e03e39e6242014db66a73070c504a21bc3646c8f56b504821513d821ccbcf5"
    sha256 cellar: :any,                 monterey:       "e21183f35650b836d5692e919d995e8a553a97b531e878fb667159abdc179dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f21abaa2dbae60d1b191e03b1d2f4151ad8569d4c8860f129ffe40426e87fd0"
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
