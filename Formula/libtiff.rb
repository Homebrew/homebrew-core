class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.9.tar.gz"
  sha256 "6e7bdeec2c310734e734d19aae3a71ebe37a4d842e0e23dbb1b8921c0026cfcd"
  revision 5

  bottle do
    cellar :any
    sha256 "619d93542a46b0b4782f0cc39e4ea568b1e05e353e6e27296cd4d2ad54a7e9d6" => :mojave
    sha256 "783fdbfa2a938c172bdb98e1a32c4b93de640eb8481f008edcf3473bef9e3ef7" => :high_sierra
    sha256 "08213b94b648c48f3561dfe459e38a90cccac68742e65283eaf57c7fb6073ee3" => :sierra
    sha256 "abe583a7e362db26f47e87864ca26bb69c69e83bdbd3b3a32b2e73bea107d0ea" => :el_capitan
  end

  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Patches are taken from latest Fedora package, which is currently
  # libtiff-4.0.9-13.fc30.src.rpm and whose changelog is available at
  # https://apps.fedoraproject.org/packages/libtiff/changelog/

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2017-11613.patch"
    sha256 "8979704198096f7bfb0a48c3be451a83f6bad6667afdc214adcd15c2b5a8f1be"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2017-18013.patch"
    sha256 "abd91c9ae48be346eb4f9fae927dc3d1fdbb8cdf210de00f79642f5630671e65"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2017-9935.patch"
    sha256 "b9c3045cc00d0d1b62ec28971dde51b4a7074d014f7ec0bc56fd1814e01e34e8"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-10779.patch"
    sha256 "ba90566a38518d8802aa65a664f4a0d63feba7f9b6d10482f3dd5eb9ccd59747"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-10963.patch"
    sha256 "4926e7b28b3e7bffeefb45b12da9d42abb7e39cbde97e1321c368438423db23d"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-17100.patch"
    sha256 "8ce12fca9564730a3b3daa9da8804e8797c1e5ab4a362d290da1ea25aca0ebb0"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-17101.patch"
    sha256 "73b5934518e754c18e0de8f114796a0821549dd7bd712078d6c89e95f5efe6a4"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-5784.patch"
    sha256 "f71f249002498ff66f422bf297aeaf56ae6980a90156386da31b29bf25b196cd"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-7456.patch"
    sha256 "6d85a740bfab67159d0f63b3b56f9d6fc8ef3540db4c04df90fdf65b07bcb8cd"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/899be6424defc28747be318e28d57a4bf9bcc7c6/libtiff/libtiff-CVE-2018-8905.patch"
    sha256 "de9630eb6ee7cfff4643c6de3d1c47a7ced5aef4c4ac4f74dc40b5211e814e5d"
  end

  # This patch for CVE-2018-18557 is not yet in Fedora
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/998152d397a12f284485777f42e9f492f99baabc/libtiff/libtiff-CVE-2018-18557.patch"
    sha256 "5ebc14638b3beebc377a7ff616e608f6a6938b28fb78b107ad790c124ad99d26"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
    ]
    if build.with? "xz"
      args << "--with-lzma-include-dir=#{Formula["xz"].opt_include}"
      args << "--with-lzma-lib-dir=#{Formula["xz"].opt_lib}"
    else
      args << "--disable-lzma"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
