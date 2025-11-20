class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://github.com/Talinx/jp2a"
  url "https://github.com/Talinx/jp2a/releases/download/v1.3.2/jp2a-1.3.2.tar.bz2"
  sha256 "e2aabc4df8f003035059996f0768b4543fd483ab8cffa5f62286a1d00ddb0439"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fcfa2040d8d6783c93a233bc0f5aa3b3a1e13103c707bdb9f227fa21b2be95de"
    sha256 cellar: :any,                 arm64_sequoia: "c57c32d5a9a823615408c17fc7692cf918beac96cd9557c54f905da5803b9f31"
    sha256 cellar: :any,                 arm64_sonoma:  "daf37f1570a9e1b2bd46b2cc0ccf57af00a813a0de9022a106e89fc7fe829ddc"
    sha256 cellar: :any,                 arm64_ventura: "1b7dbe456e302277e7ff10a79e3999b35672855ca3a04425cf89572df87bf5b4"
    sha256 cellar: :any,                 sonoma:        "1c5b176bba2e8ae0d825761da452a334d11411637342a159fecc6c9add83c5bf"
    sha256 cellar: :any,                 ventura:       "e9b1cca5d32321539eec19f0e0c037a8e137cee43448a04b135f620df806478d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e7349e6c5c24351b4b2881ff6f3b14fa25e8eb7c0301f640a9a5664c8257da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00f6f42f5d2ef84ddc1a42004e9c44789be388385a454215e02dfa9b07c1bf43"
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
