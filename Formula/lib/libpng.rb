class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "https://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.58/libpng-1.6.58.tar.xz"
  sha256 "28eb403f51f0f7405249132cecfe82ea5c0ef97f1b32c5a65828814ae0d34775"
  license "libpng-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "02e4e023512c6bf086f139717bcb90fb53ece5fbab3ab4354b0d5fed25afa5db"
    sha256 cellar: :any, arm64_tahoe:       "afb3b4e1b5035a602d60668b8a16369704dfa32aca18330f4e0faaec54b3134f"
    sha256 cellar: :any, arm64_sequoia:     "bc998bd8497a87e10e613348858c295a38f29f12914408ccbec81f0d0c2e77c8"
    sha256 cellar: :any, arm64_linux:       "36876a725450f53a659f499b1bae414674d451ee558c59b14a76a459dd1b31d5"
    sha256 cellar: :any, x86_64_linux:      "fef7fad4ecddc7ba44bd310ef6fbdbacbadeb99027577e3df1f05bd330554eac"
  end

  head do
    url "https://github.com/pnggroup/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"

    # Use Fedora's regenerated test PNG for zlib-ng-compat compression
    resource "pngtest.png" do
      url "https://src.fedoraproject.org/rpms/libpng/raw/49e9a06ca115aaa911dd3419ee79c1870d1428fb/f/pngtest.png"
      sha256 "f925a657a5343cfb724414c01e87afd4d60b1f82a46edc0e11f016a126f84064"
    end
  end

  deny_network_access!

  def install
    resource("pngtest.png").stage(buildpath) if OS.linux?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <png.h>

      int main(void)
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
