class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.4.0.tar.gz"
  sha256 "8643d50ed40c759f5412a3af4e353cffbce4fdf3b5cf321cb72cacf06b2d825e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a789c0f212b5e1d06acc213bda685bf97e3036f89d8f4d2580b29bac32b3d3d" => :mojave
    sha256 "078eed374d5df2b561c6d36fe7284946f0556ba450e86fb048ca443cd4e3d894" => :high_sierra
    sha256 "fc7b2124e4d4bdb8df5e41e9b5992d151e7505e71e790f9e53ac8a7cdd55490d" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "xz"

  def install
    system "./configure",
           "--prefix=#{prefix}",
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

    system "make", "install"

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
