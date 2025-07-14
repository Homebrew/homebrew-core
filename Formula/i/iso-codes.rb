class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.18.0.orig.tar.xz"
  sha256 "066bc4df7bf299561856a07119cde01d563c8c4c39906537a39363bb833d466c"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git", branch: "main"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/i/iso-codes/"
    regex(/href=.*?iso-codes[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c15c05f6acf542ec524347a70aa893262931fe44c6b4e3ee737ab721b72aaa8a"
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
