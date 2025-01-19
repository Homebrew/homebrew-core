class LibcdioParanoia < Formula
  desc "CD paranoia on top of libcdio"
  homepage "https://github.com/libcdio/libcdio-paranoia"
  url "https://github.com/libcdio/libcdio-paranoia/releases/download/release-10.2%2B2.0.2/libcdio-paranoia-10.2+2.0.2.tar.gz"
  # Plus sign is not a valid version character
  version "10.2-2.0.2"
  sha256 "99488b8b678f497cb2e2f4a1a9ab4a6329c7e2537a366d5e4fef47df52907ff6"
  license "GPL-3.0-only"

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
