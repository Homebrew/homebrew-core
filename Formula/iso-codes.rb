class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.6.0.orig.tar.xz"
  sha256 "41c672c18554e979e6191f950f454cdf1bfb67a6369fffe2997ff68e34845409"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3720db3c8b9004255cdd38b9922a551dd13050102fede5691b0aaec6ac5a916f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b187032bee03cffb5e57f2a609f31010b3572a7dc20e74863f5058fe084a59c2"
    sha256 cellar: :any_skip_relocation, catalina:      "e842954d1e655188d47362cabce2af5585dd5f9f7687f6d70c14e951374918b2"
    sha256 cellar: :any_skip_relocation, mojave:        "172c9bad5734b7fa56f77c1f2a73e9db2f7d9492c3b40a11941b57b294cc554a"
  end

  depends_on "gettext" => :build
  depends_on "python@3.9" => :build

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
