class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.10.1.tar.bz2"
  sha256 "ec5e44d3cfe6f50f1c64f28a6f0225d958f4f4621726d9c2a04b5a32e5106d23"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "508a148f99cffa1debe9eb1dcde4a4214e8d70999e55ed671f46d3fac9685c5a"
    sha256 arm64_ventura:  "08edcc8a994aa324b995e591137c5876efabec2cc6cedb1a16e580f606cd094f"
    sha256 arm64_monterey: "53351bac6158e2ddb784f23c72e272ece2f1282e8d800483a430f44ed8856bd4"
    sha256 sonoma:         "05d36e9ad10f17f9acd78d0495176079fe213f0a2352b624b07fd0e14c8dc8de"
    sha256 ventura:        "b9e014a3b635d479cd0f31c9ab330770bd31dcebea1358f3c808baad654694b0"
    sha256 monterey:       "70d56833e112620ffe7be807eee3b9b7b4d566613596e8cd793ceee4b1cab875"
    sha256 x86_64_linux:   "79a43c19637de9ab8bc7f82ef394b0ffe519324830e452d23d7b47e51a249785"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
