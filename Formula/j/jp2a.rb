class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://github.com/Talinx/jp2a"
  url "https://github.com/Talinx/jp2a/releases/download/v1.3.3/jp2a-1.3.3.tar.bz2"
  sha256 "8aa995f570235321c94dcf705ca12d3e499f2a6b78213698de3c152534e38c0e"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2b8603ab0f2a1415dd3813da7096f960a788fe1200329038bbed63190474283"
    sha256 cellar: :any,                 arm64_sequoia: "a5de8e7c8f37a34ff6f7e997926b0bc68000abca2297cf9fa69ae1fc094f00c9"
    sha256 cellar: :any,                 arm64_sonoma:  "ffb9e2fd0b50344cdf6cecc7d54c9b7619b5e00e6753d993e55b8e402f4a1755"
    sha256 cellar: :any,                 sonoma:        "0cd318bb145b4610b0333ddb507dbda4efa06a3f22ae3e7bc5321c957ba54a2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af23c2b99ea3375f5a93216a3caf26e6ec581439d14819dacd0285305ae35c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9633dd8cfdd391b105cbc60f4211980bde6a830a3d212d5d7081794c5c1d0b59"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "webp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
