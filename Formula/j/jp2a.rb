class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://github.com/Talinx/jp2a"
  url "https://github.com/Talinx/jp2a/releases/download/v1.3.1/jp2a-1.3.1.tar.bz2"
  sha256 "a646f893508b111d922d5f726953d577089741b83fa299f351c98e7be7974c9f"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48a62bab6e6137a966a84aa358bd89951a08f4804e68ed8ddb62dd1aaa440d03"
    sha256 cellar: :any,                 arm64_sonoma:  "54e7f74dc31bc89460ad5990a4edfd48f84ebf8157b5db704108d65d4cf3fec6"
    sha256 cellar: :any,                 arm64_ventura: "ad160d25da5c3d94096f8df247ed23b768decd6e09ef1e41eb10cc209dff70db"
    sha256 cellar: :any,                 sonoma:        "35c9ffafbe8be311bbc70d882d6a3d947845d64c1de25bf27f16e064b8e44478"
    sha256 cellar: :any,                 ventura:       "d10a7ed7431a73c496aef8611d8b6d4688944776b0717b2e8c53ae7e9dd67e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42afb7dedf59ee0ee8bc3ad0ff12fc6f3a3c844fcf1d654a36c1991e85bb6bdc"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "webp"
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
