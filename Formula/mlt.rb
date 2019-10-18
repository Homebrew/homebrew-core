class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.16.0.tar.gz"
  sha256 "9c28e54cd3ae1d43f8d0d4a24f9cee4f4b161255a3cd2aa29061fce5d46158e6"

  bottle do
    sha256 "5bf6b9ab95cc0a74d9d30efba8d6fb40ec674b7d379a60026bb7d1f621732fd6" => :catalina
    sha256 "0130bcc2270ab5a0522151f686c86d26196aa4064ebea87055f41fdb9e59a724" => :mojave
    sha256 "4857e26881ee1b47617a24c27a2234c9ac2fe08b170030b11d5130c976a53eac" => :high_sierra
    sha256 "32eb8106b195c417339203b630306ef365a01f6667114ed92e74ab3761b68e05" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sox"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-jackrack",
                          "--disable-swfdec",
                          "--disable-gtk",
                          "--enable-gpl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
