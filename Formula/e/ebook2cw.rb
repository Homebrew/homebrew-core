class Ebook2cw < Formula
  desc "Converts ebooks to morse code"
  homepage "https://fkurz.net/ham/ebook2cw.html"
  url "https://fkurz.net/ham/ebook2cw/ebook2cw-0.8.5.tar.gz"
  sha256 "571f734f12123b4affbad90b55dd4c9630b254afe343fa621fc5114b9bd25fc3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fkurz.net/ham/ebook2cw/"
    regex(/href=.*?ebook2cw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "cd48218169f8f598c5bbba765d4f632fd51eb0472e2416856008b0dd79c1c83f"
    sha256 arm64_sequoia:  "8ee60330873ad88bbe4346269b4ce0f1c1598382e98ebfae5a264d8af4474148"
    sha256 arm64_sonoma:   "db414d0d717be52093b787e79f866d82e2f91fbdf7290b89b194ce5da6a2116b"
    sha256 arm64_ventura:  "b489e82a61e8939850597bcfe3a9f550171ee9a60c192677e9d7882d7ab6d9da"
    sha256 arm64_monterey: "51fa1ee26a03240c46e41a82f8aec2b3c6adb240df22906d2d7515e0c416d766"
    sha256 arm64_big_sur:  "3a135e19472fa1cf7c261704d9b6731c3d7ed11e16146141feac522d6cc9a735"
    sha256 sonoma:         "b2e633fc299f13bcfb391665dc4d2693a5a7bbc9dbbb304c14772c22460bb5a5"
    sha256 ventura:        "eb4f79ba7941e073eb076731d020a3c948b086602b18eaf27dd819e51611d9f5"
    sha256 monterey:       "875f2b989098018048e20711591dfde60aa903c6aaf9a18b7850a4388898c741"
    sha256 big_sur:        "07d3d9f7a7446a9686a1a2052fca0f7fc40e1b111445e2cba1425fbd7afbbb4c"
    sha256 arm64_linux:    "65bb32893afbbf13664b9cad4885392d89f3129483d274d46b0f690b492c2706"
    sha256 x86_64_linux:   "269994f635db4fc4570e9d0684051e883bbfba824be06bd8bf420ed8189fdf2b"
  end

  depends_on "lame"
  depends_on "libogg"
  depends_on "libvorbis"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build # for msgfmt
  end

  def install
    system "make", "DESTDIR=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    pipe_output("#{bin}/ebook2cw -o test", "test mp3 file generation")
    assert_path_exists testpath/"test0000.mp3"

    pipe_output("#{bin}/ebook2cw -O -o test", "test ogg file generation")
    assert_path_exists testpath/"test0000.ogg"
  end
end
