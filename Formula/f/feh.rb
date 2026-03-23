class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.11.3.tar.bz2"
  sha256 "f2cca3592a433922c0db7a9365fd63e5402c121d932a9327e279c71be6501063"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "855a10dc5899354d94b6dda82e715f05d56e53bb31d8977da1088536a7da7c0e"
    sha256 arm64_sequoia: "6df8767b5680c95825e5b482432f53c308f8c27451b93852bcecd4255c6f198c"
    sha256 arm64_sonoma:  "6f417a18c16c26939c37770ad0410f4a83d747b9ec62c78074a1b6e299c05d23"
    sha256 sonoma:        "19dc6999bb9cc255c23ecb81920181539d7bd7a906898fc9d5382f5d6cb9d0a4"
    sha256 arm64_linux:   "23653e63d4d90c61fb8790ff35c4b4983794e6946428dc200d5d7d0d8ac48d5d"
    sha256 x86_64_linux:  "cac79626c41c6eade6c1a8f59afaf420659a11537eb287973341667e75e07b3e"
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
