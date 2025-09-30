class LibcdioParanoia < Formula
  desc "CD paranoia on top of libcdio"
  homepage "https://github.com/libcdio/libcdio-paranoia"
  url "https://github.com/libcdio/libcdio-paranoia/releases/download/release-10.2%2B2.0.2/libcdio-paranoia-10.2+2.0.2.tar.gz"
  # Plus sign is not a valid version character
  version "10.2-2.0.2"
  sha256 "99488b8b678f497cb2e2f4a1a9ab4a6329c7e2537a366d5e4fef47df52907ff6"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5107f894005e9d2dd51fbd16b522d244335231b572232e18a95ac838e2495d29"
    sha256 cellar: :any,                 arm64_sequoia: "fb138d8a79b5fa0eecf89a7ca0bcd3b294120aeb05200767558b61d3e4e51533"
    sha256 cellar: :any,                 arm64_sonoma:  "d91bce7e9b1ecda7021bea7ede886f35e7414f691f06e7f5ca76ffce1d8693f3"
    sha256 cellar: :any,                 arm64_ventura: "0d2130ca34ade60885f0838c9032563a1cac1267b9c88c99c6e87c1922f8b513"
    sha256 cellar: :any,                 sonoma:        "8b89fb7bf1812fb9bd7910ab0a323996aade2c07bc46a8a163843fff6c531776"
    sha256 cellar: :any,                 ventura:       "7b9d73af248b22fab2504e019d3c62daf93e8c6beb91ed9f463905f1e066b514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a1ec8c229b09241872472ddddea228bd4a8aff3ea7406a8148a12ca78c7b333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1e9aab49489534af51d75d1b222be76479ab2d15cfebc930ca570be8dd0d95"
  end

  depends_on "pkgconf" => :build
  depends_on "libcdio"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match(/^cdparanoia /, shell_output("#{bin}/cd-paranoia -V 2>&1"))
    # Ensure it errors properly with no disc drive.
    assert_match(/Unable find or access a CD-ROM drive/, shell_output("#{bin}/cd-paranoia -BX 2>&1", 1))
  end
end
