class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.15.0.orig.tar.xz"
  sha256 "3d50750bf1d62d83b6085f5815ceb8392df34266a15f16bcf8d4cf7eb15d245c"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git", branch: "main"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/i/iso-codes/"
    regex(/href=.*?iso-codes[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb76e08c6a6d3f6b9d516a11c2cfaedf36544af7b604108a4f9c58ffa6ac159b"
  end

  depends_on "gettext" => :build

  uses_from_macos "python" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
