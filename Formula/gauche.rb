class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6d7406def914577f32cea82af22920e4be9dcf8465ea89b594b8b53eed6c9abc"
    sha256 arm64_big_sur:  "d028b131ffcbe25a756e86f77617ca756e23ce97ad64f87f70e8a1d01dad8cef"
    sha256 monterey:       "70393a92c73c3d1d5d9d20a047c059994de76412a32d2750c45600a431194011"
    sha256 big_sur:        "86c00e06332efe038ba894bfccedfccb91be22ab37214b4c2f4b469d5e92438b"
    sha256 catalina:       "4054f4d238e0cc4bdb5634940a8d3cf5bb07e5d23efd3023ef05e5d9ab6d8002"
    sha256 x86_64_linux:   "49bd5b315e7e7d53155746ef19de207f51a61c01b6a5c30382e492ab008b42cb"
  end

  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
