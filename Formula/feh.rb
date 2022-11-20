class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.9.1.tar.bz2"
  sha256 "455c92711b588af149b945edc5c145f3e9aa137ed9689dabed49d5e4acac75fa"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "318f271466915108c46c98cee24d184cd57a51cc4ef016fe96d022fbacdba99b"
    sha256 arm64_monterey: "c611e253236ccd37d622f30ba046ca6f305310b58d30fd101aeaa9c9b0086a89"
    sha256 arm64_big_sur:  "3f45f1225748f51785f82480132ee9d4a3fa70fe96345876a7b9d56506b55232"
    sha256 ventura:        "7de25031dea98c15f0ac3f367b611d0ef3a60efe6793a2389cf505399991ac36"
    sha256 monterey:       "ca3909cf947ecaad1c2c330bcdfb4000ebf0ff3bb131822f144d2fffc57b6f7e"
    sha256 big_sur:        "55976a0333f38c44383fdf08263c5e596510e2e2890a558245acbca1b0a41188"
    sha256 catalina:       "1772f5711f9db52fa7d183eba8c1fb4086f2edc4900b2cefd3d6d8d80b82c7ba"
    sha256 x86_64_linux:   "7ab05a152a591c00a7b0b6b87734df10c6bc734f73126ba6c666e62e0f73c8a3"
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
