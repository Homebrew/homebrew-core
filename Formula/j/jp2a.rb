class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://github.com/Talinx/jp2a"
  url "https://github.com/Talinx/jp2a/releases/download/v1.2.0/jp2a-1.2.0.tar.bz2"
  sha256 "bf27b42defa872a2a6b064e89b5e09bd6d822aa63e2d0f42840fabd0ce5d49bb"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "874626298e9ec3382fec6b0959bfd2c03de419640ada27d70547012c0fee1b9b"
    sha256 cellar: :any,                 arm64_ventura:  "cd1ddc8d78c2b8391a7fd5b69ac9357a7105a223029ca3d4a691f5a6e57f57ca"
    sha256 cellar: :any,                 arm64_monterey: "7e104bb6a94326ac330df1daeed8424a92e9ca66d02a681c892bac0ccb20df9f"
    sha256 cellar: :any,                 sonoma:         "06689dada11615dce0fc563c73dd91b4ff8a2c8f0b08936381392a29de81fe88"
    sha256 cellar: :any,                 ventura:        "ec87f44c1fa6669a6ab3f0d7ac08c4746e6966416b3ae2ad2d88a9545622fe70"
    sha256 cellar: :any,                 monterey:       "e97f337a7a7120c1a7f352e810f3e307be24a46cfdfdd957a21998fbc34d2e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "626b7dd604f1a12c799d2e3b73241fd874adbb5032ce853519de4fce554c4d83"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
