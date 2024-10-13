class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.10.3.tar.bz2"
  sha256 "5426e2799770217af1e01c2e8c182d9ca8687d84613321d8ab4a66fe4041e9c8"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "03b543a2d8877b5113e8e539ead4ac474cc752e73552eaa61112c7b76b426614"
    sha256 arm64_sonoma:   "d03c242ca267dcb850ea99487d1aaebd074f8ec55b6243e2873cd37b408ba599"
    sha256 arm64_ventura:  "a4633eff1f55706325a815ab32490c90c8292d47a823ff524e1cc75f246a7ed3"
    sha256 arm64_monterey: "6d34e4281efec9c7b96452d199427705cee39583ebd2b4327c90287266296ba2"
    sha256 sonoma:         "e654d6e73ff32e16743333fd0525b18697a95b326900caa552840a675cb8ff51"
    sha256 ventura:        "8596aca255c4f0c59e074c29379f67bea2ae0bf60fb3c291f3daadca8c2dcfa9"
    sha256 monterey:       "9f9352b3c8f466864d188f4ae685c49f0e134a5f8806b696e89fbcd8770ebd45"
    sha256 x86_64_linux:   "ed7a6b2ac64f87b5a2fe8e77eeb4f4f787da91801f76ca5fbc4c27d251152329"
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
