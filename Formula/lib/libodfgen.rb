class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.9.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.9/libodfgen-0.1.9.tar.xz"
  sha256 "b68ec10c23b8ac7abed8dfeb181b8592714c1e5bd33997ced0ee8bd6c4612bc5"
  license any_of: ["MPL-2.0", "LGPL-2.1-or-later"]
  compatibility_version 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libodfgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "21de7b0286b5f16a232fbb4456b4ccddc335e12b80ef1df9a7aa318c4fa6c1e2"
    sha256 cellar: :any, arm64_tahoe:       "e5ac413589685636fca66be3533d82b03871f6212b7b3ffa07ea79247ba86407"
    sha256 cellar: :any, arm64_sequoia:     "c5139571193f9ce15055aef6f5ce47184987a813f8b7bb65ba2dbb1cf853362e"
    sha256 cellar: :any, arm64_linux:       "aff3f9f9a20f03a91c2467fd1d1397e10efeb78ba94468d18e5d96f19729fd47"
    sha256 cellar: :any, x86_64_linux:      "779e70f0677f2d6e66953eaa0583dda710fb3eff341c7d1cdce83fec5ac93afb"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-static",
                          "--disable-test",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}/libodfgen-0.1",
                    "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                    "-L#{lib}", "-lodfgen-0.1",
                    "-L#{formula_opt_lib("librevenge")}", "-lrevenge-0.0"
    system "./test"
  end
end
