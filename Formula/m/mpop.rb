class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.22.tar.xz"
  sha256 "2cd64a9c29a5ade3429230c70610ca4b6ea305fbc264f6961b5d85a7a8cecd4b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "53077e036b6576977a9c436f7dc0a343d8be4c36c9c9c24c54f2862b663e7cfd"
    sha256 cellar: :any, arm64_sequoia: "99d5d3dfbdf22b80e681c776f59bee6b67a5b278b94a56e63a78a1069c71722e"
    sha256 cellar: :any, arm64_sonoma:  "eff5394314ed0e2bbc35f930ef329aaf8ebb18e6483ff4409a20cbf7931adab7"
    sha256 cellar: :any, sonoma:        "162a9fb57ad8901c636c5a6c355c2defb42e759d988e8183e61bf35ca2539f1f"
    sha256               arm64_linux:   "5acc22bcfe9c1230a2e0c735b1152433245d6e8416a9f3006392cc565942a7cb"
    sha256               x86_64_linux:  "b41b1549f6b8f4be5a2fa1012ef43c06ed002fe873b01684be3d7c3c4c95ac7a"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libidn2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # gnulib's base64.h (vendored in 1.4.22) uses `bool` without including
    # <stdbool.h>, assuming C23. Force the include for pre-C23 compilers.
    ENV.append "CFLAGS", "-include stdbool.h"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
