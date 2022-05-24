class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.9.0.orig.tar.xz"
  sha256 "d090112a529dbe37a0a1b46b8246cc1cfca92e0281ba27239426a2b693e28967"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git", branch: "main"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/i/iso-codes/"
    regex(/href=.*?iso-codes[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eec87541cb08d1862596b5768b2ee076259475a2b3d3d966acffdaf91d0f3388"
  end

  depends_on "gettext" => :build
  depends_on "python@3.10" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
