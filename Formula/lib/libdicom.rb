class Libdicom < Formula
  desc "DICOM WSI read library"
  homepage "https://github.com/ImagingDataCommons/libdicom"
  url "https://github.com/ImagingDataCommons/libdicom/releases/download/v1.1.0/libdicom-1.1.0.tar.xz"
  sha256 "058bfaa7653c60a70798e021001d765e3f91ca4df5a8824b7604eaa57376449b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e04c4b953a01ad22ad1b0a275e125572ad56724f72b1e0722c995889f2100128"
    sha256 cellar: :any,                 arm64_ventura:  "4d7c3ec3e97cf15b3e880f105d2abc5293ab53df9987b572c10c1f223d920fef"
    sha256 cellar: :any,                 arm64_monterey: "5da10c0fbf8863b894a4991e19e126dead1746a2fc364fb30916f8c256a12de0"
    sha256 cellar: :any,                 sonoma:         "9a0b6ddb37db98584843c42e5542f24b9d8e8ec6cbb431cc9c972578b4acb2be"
    sha256 cellar: :any,                 ventura:        "211edda989f53885f744b7dfdd930277a2197819ceca052a3f03a281c10d7f55"
    sha256 cellar: :any,                 monterey:       "7bf20b6f29eff5ba9c9cf2dc33a447775af8d84eedb1a6405a856b882f7099d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12aeb51a6477d922ae32934b31abfd489853b8a40833f78ba2bf9c00d82b631c"
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
