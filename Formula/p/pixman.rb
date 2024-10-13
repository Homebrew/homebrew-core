class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.42.2.tar.gz"
  sha256 "ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "f215e1e85be34c4b7ba664ee965ad4c76c6af611884b3af4cf7a3ae36e13351c"
    sha256 cellar: :any,                 arm64_sonoma:   "d355a294d3f9152479c2c0905efbeb329aef9cb27b9ae12e2a4ea6a4f41f2174"
    sha256 cellar: :any,                 arm64_ventura:  "e27867c503bd9cf858159261e053184d19ae00357dc89426810f80734aaaefd0"
    sha256 cellar: :any,                 arm64_monterey: "5270c55dc707a887b832b47324b82a6e69657ebb7ecd72843080f1e54a5bfc8b"
    sha256 cellar: :any,                 arm64_big_sur:  "999830935fa581f1598d56834060bbfd8dbe818513ab39a1a15b1b5e0ef2afd9"
    sha256 cellar: :any,                 sonoma:         "73469a943a06d34ae520803be550773c148f93b51e1e4a4aaaf9d59e16a8509d"
    sha256 cellar: :any,                 ventura:        "84c3bfc0a0e43b714fd064954885314b4ec2928571ba43c49760cacca50bd32c"
    sha256 cellar: :any,                 monterey:       "2a61150890d26395ae8d8c0afd7423bdea2cfe3cbc7feea24a4450cdd0804fc5"
    sha256 cellar: :any,                 big_sur:        "9c50d2fadad622cf5b80f24dffb5e5b2edfd0ff91927a2143ca27bbcd392a4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf9d788868c9609f6e3ea3798d93076c7b2b1b8ac7f63527f7e0bed89dc1957"
  end

  depends_on "pkg-config" => :build

  # Fix NEON intrinsic support build issue
  # upstream PR ref, https://gitlab.freedesktop.org/pixman/pixman/-/merge_requests/71
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/46c7779/pixman/pixman-0.42.2.patch"
    sha256 "391b56552ead4b3c6e75c0a482a6ab6a634ca250c00fb67b11899d16575f0686"
  end

  def install
    args = ["--disable-gtk", "--disable-silent-rules"]

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
