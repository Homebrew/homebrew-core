class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.8.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.8/libodfgen-0.1.8.tar.xz"
  sha256 "55200027fd46623b9bdddd38d275e7452d1b0ff8aeddcad6f9ae6dc25f610625"
  license any_of: ["MPL-2.0", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libodfgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f322394dcaf548a6c82e55f4d39ddc2c35aced9c316a07c8ddf491f2735be66f"
    sha256 cellar: :any,                 arm64_sequoia: "c1c268be3d7429eef8c2dee45c01e2879270b04c85380ee2c7bd7f64283ccfd2"
    sha256 cellar: :any,                 arm64_sonoma:  "8a6f092b8f4f3dde336f3c6aa803e4992356b0b42540fe18fd8fb0f20dcea521"
    sha256 cellar: :any,                 sonoma:        "b826aea071dcf4ede7649c6c0c0eeca0f16cac90196f66572fa7373e33fca2e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404a532810b4c156d28f6c297037a9cf60110bfc435101e8a9a6b2e7405e9eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334e33d8a2c52579f1aafd79f4b27b57d50bc8f663b88d884e8725f69bc849e5"
  end

  depends_on "pkgconf" => :build
  depends_on "librevenge"

  uses_from_macos "libxml2"

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
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{lib}", "-lodfgen-0.1",
                    "-L#{Formula["librevenge"].lib}", "-lrevenge-0.0"
    system "./test"
  end
end
