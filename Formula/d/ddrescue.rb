class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftpmirror.gnu.org/gnu/ddrescue/ddrescue-1.30.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.30.tar.lz"
  sha256 "2264622d309d6c87a1cfc19148292b8859a688e9bc02d4702f5cd4f288745542"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc0e5a061cda75c11f3bfeacdfb4283ed7c71c6f79a93923cd136bfc5fd3145f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47034be3aabaec1811ca62c8893dd7f9db1dfdbe77f934e9bb98f9aaaa9f2838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f56c40fa3614f382c9ea4b2dccbce5b82eb3e4ecc3555aa05d181e55f3178852"
    sha256 cellar: :any_skip_relocation, sonoma:        "15b4e4107e9c90de349c137f81159b745e1f982b5f18a6fb58c6ee74f0ecf16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3989dc866dfac473c310d48663f6031ad43d29e4e2c5e668b2e07dd3dfb72fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3f54e1611eb72a3326d5dafd360801a32dd4b397801f491b142afbb7be253c"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", File::NULL
  end
end
