class LibcdioParanoia < Formula
  desc "CD paranoia on top of libcdio"
  homepage "https://github.com/libcdio/libcdio-paranoia"
  url "https://github.com/libcdio/libcdio-paranoia/releases/download/release-10.2%2B2.0.2/libcdio-paranoia-10.2+2.0.2.tar.gz"
  # Plus sign is not a valid version character
  version "10.2-2.0.2"
  sha256 "99488b8b678f497cb2e2f4a1a9ab4a6329c7e2537a366d5e4fef47df52907ff6"
  license "GPL-3.0-only"
  revision 1

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "73510e98664655e2f3034b967cc480fa20651cc241e3516452ad8ec826c74484"
    sha256 cellar: :any, arm64_sequoia: "82158889e0e871069ebf270e7f5d16492f63e2333b987d5a350ae33ff3f178b7"
    sha256 cellar: :any, arm64_sonoma:  "59f8c2ec7d7a7ed0ded06916eb4260ffd9f19d0375f8b714a0a8cbb3094a41f3"
    sha256 cellar: :any, sonoma:        "524b0159b361dbe6225bc405283e09b821733ed483bfd29f9ce1d9c145c8ef34"
    sha256 cellar: :any, arm64_linux:   "b8c497f19d5b22a99bc3a3511c702a7a0aadcfdbe95f15e683e914a3879739b0"
    sha256 cellar: :any, x86_64_linux:  "b2103860f0925b8a6dc2a0bcecb3c2367190df1814f142f4ad8f3069737be2a8"
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
