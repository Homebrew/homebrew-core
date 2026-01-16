class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.20.1.orig.tar.xz"
  sha256 "5d551f3ddb32548c4321e9011720fd97751af0107592f79ebffc939bd32f2268"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git", branch: "main"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/i/iso-codes/"
    regex(/href=.*?iso-codes[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "759f0f3e98ac876c7b1a1a60a604fc391ba091275ebae662d76e2f255c5c7ba9"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_15924 iso_3166-1 iso_3166-2 iso_3166-3 iso_4217 iso_639-2 iso_639-3 iso_639-5", output
  end
end
