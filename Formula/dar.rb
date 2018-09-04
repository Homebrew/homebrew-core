class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.16/dar-2.5.16.tar.gz"
  sha256 "e957c97101a17dc91dca00078457f225d2fa375d0db0ead7a64035378d4fc33b"

  bottle do
    sha256 "ade6a894717bc00148d259f5c48b19172f12a307b84d2003f9a56ee95017d0a4" => :mojave
    sha256 "b8e79c81345db6df1b985d0b05d7fef3f0f72c3a0dfd356cd048de5e483f31ed" => :high_sierra
    sha256 "235d95dab2ef03ef746019989ca0939602903d79505bc3767d974f411996bb6b" => :sierra
    sha256 "0f3d68d33877c3d98b9d8fbacdbd52c54569ccc1a46130ecec244415c58c5c73" => :el_capitan
  end

  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-libgcrypt-linking",
                          "--disable-liblzo2-linking",
                          "--disable-libxz-linking",
                          "--disable-upx",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
