require "FileUtils"

class CifApi < Formula
  desc "C API and reference implementation for CIF 2.0 (and earlier)"
  homepage "https://github.com/COMCIFS/cif_api"
  url "https://github.com/COMCIFS/cif_api/archive/v0.4.2.tar.gz"
  sha256 "803fa1d0525bb51407754fa63b9439ba350178f45372103e84773ed4871b3924"
  head "https://github.com/COMCIFS/cif_api.git"

  option "with-linguist", "build cif_linguist (experimental)"
  option "with-docs", "build and install html documentation and man pages"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  if build.with? "docs"
    depends_on "doxygen" => :build
  end

  # icu4c is provided by macOS, but does not include headers nor pkgconfig.
  depends_on "icu4c"

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-debug",
      "--prefix=#{prefix}",
    ]

    if build.with? "docs"
      # Note: this is necessary to enable *any* documentation building.
      args << "--enable-doc-rebuild"
      args << "--with-docs"
    else
      # make install fails if this directory does not exist, even without docs.
      # When building with docs, make install will (correctly) create this directory.
      mkdir_p "#{share}/doc/cif-api-#{version}/html"
    end

    args << "--with-linguist" if build.with? "linguist"

    system "./configure", *args
    if build.with? "docs"
      system "make", "dox-html", "dox-man"
      system "make", "install-html"
      man3.install Dir["dox-man/man3/*"]
    end

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cif.h>

      int main(int argc, char **argv) {
        cif_tp *cif;
        int err = cif_create(&cif);

        if (err != CIF_OK) {
          return err;
        }

        return 0;
      }
    EOS
  end
end
