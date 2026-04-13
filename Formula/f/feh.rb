class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.12.1.tar.bz2"
  sha256 "6772f48e7956a16736e4c165a8367f357efc413b895f5b04133366e01438f95d"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d125fcc727286d6f936a304c25b9aaea87190a9c1610a5ea61d4b69600db57d9"
    sha256 arm64_sequoia: "c2c3feb79abb0904ce88f4448c4e9f2e9505d474cf97c255ec3be0cbceb08b6c"
    sha256 arm64_sonoma:  "ea3fb1a1c4bb0a98bb0398df78aa0b4dee45162de111ec18b58b48edeec54e00"
    sha256 sonoma:        "e439ec50cecd61bf2f5fbdd8ff52116b3f6ba70ea17dddd0eb1005ac7d7d1a94"
    sha256 arm64_linux:   "3a45c29c3294ef9e5a0046ddbaed2d10b8763ed7e24cf2672a8f538a3ed44823"
    sha256 x86_64_linux:  "979d35e8be0131e6b7cbd508a91692ccfbc93f555921204fba4a178294f75bd9"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
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
