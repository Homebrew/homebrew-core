class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.5/fs-uae-3.0.5.tar.gz"
  sha256 "f26ec42e03cf1a7b53b6ce0d9845aa45bbf472089b5ec046b3eb784ec6859fe3"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "37e9318b578ea42dbfa769ecc23bfa7bf91a25417a6145db56d415fafece7dd2" => :big_sur
    sha256 "ab0fdecdc3ee1e4ed70baf7a57bc46d92b85b684c97d680c9fbfab5b280a7da4" => :catalina
    sha256 "223c490857dc42ec051f68531fbcc2ceffd142cd8f56b4b18a0d1c2134c6fb03" => :mojave
    sha256 "61bfc89218feb2fb4ae2da82e68d4d81dcb40d7ce6003d0a5d39f675b6327f11" => :high_sierra
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "sdl2"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
