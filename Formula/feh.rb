class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.10.tar.bz2"
  sha256 "1d71d1f6dcfe9ffee5e2766969a11978f7eb4fac7d7ae556f104c11f9c57cc98"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d09345a22a4d8c83ce3dcf08c7094bc487c6ca6c3c68909b58a6b5c5fbe42fe6"
    sha256 arm64_monterey: "5ff27ed211a8b9be511a8f15482247a7ecfc85a916827eaa1c71397b71b28df3"
    sha256 arm64_big_sur:  "799e3e81bd9ab5ce239bdf12014c92ddabf1eed3a0191da5ae042159107ab051"
    sha256 ventura:        "89580584fd9466914862b6e5f61c49633fc8bf371ef7e891bf660e943925cd6a"
    sha256 monterey:       "c29cbf93477a53aa44292a702596c7e96028f285c599121ac6e3c4ff9e732452"
    sha256 big_sur:        "ce60ede12373dac7aa745bb98091b3d145689b589a4898f8d7f6a989bbeb18c3"
    sha256 x86_64_linux:   "1ea557203296659043d36e6dbfc2491dc84188af3732ffc158c22134910c042e"
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
