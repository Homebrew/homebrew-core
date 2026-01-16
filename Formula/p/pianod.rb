class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-420.tar.gz"
  sha256 "9fa739cf28d5f554d982acecb94857b9fe0d0fd839d238dfca90f143c9fab216"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b623727180aca736393b728354e2ac5f3b265141c93b9a726dd6d7d440038172"
    sha256 arm64_sequoia: "f7d2ba1c1152ea177cf01d2238a332addc20a9d19092d4bb5ac1fb34a00fcc1a"
    sha256 arm64_sonoma:  "2d937b02a8431acc858ed326662072ff33c84274921aa2749facdf8124b2ebc6"
    sha256 sonoma:        "c3e1a56ec0fb9d96950cc4b9ef61973a8d0f20c486e84ccb77f35ac86a57e4a7"
    sha256 arm64_linux:   "119a870280b5f91d8c0f9571db0bd6c09441a75cc3df34357f1eddff7817e916"
    sha256 x86_64_linux:  "aab5825968b3667c5403f80fe2fb0e1ad1f4a5c5ea6f8e6b02dafa477284594e"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pianod", "-v"
  end
end
