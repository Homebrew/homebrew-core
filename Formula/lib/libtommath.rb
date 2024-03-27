class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.3.0/ltm-1.3.0.tar.xz"
  sha256 "296272d93435991308eb73607600c034b558807a07e829e751142e65ccfa9d08"
  license "Unlicense"
  head "https://github.com/libtom/libtommath.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77c834f9f46a9221140b4df7da974f77e53b72dfc16c79ddf6430f9c5862fcf7"
    sha256 cellar: :any,                 arm64_ventura:  "67fecb858905f1be42fe9aa1985dafa513595eeb12a84e2dd65fc302d2b5eee6"
    sha256 cellar: :any,                 arm64_monterey: "7298dbb765d55fd71973ce757792a864c1ae48eca0a128f3e8f47a0f502f60bc"
    sha256 cellar: :any,                 arm64_big_sur:  "644af3cb45ff79d1827281187448ca8c7541eb413cfb3b05fdbf789885852956"
    sha256 cellar: :any,                 sonoma:         "9efdc36a2a3640e11e5d4048208d88d15b6a23b6ed374d0654b449afdd64f23e"
    sha256 cellar: :any,                 ventura:        "0a9092c55794529aacde5f3198881bd6198833062a2378be448dcc530a8fc41c"
    sha256 cellar: :any,                 monterey:       "37b0636667a1562595fd0308f765005c6d1f0099d7f6a8c043313721b7410b29"
    sha256 cellar: :any,                 big_sur:        "cfa35220c9bdce147e1cd61750eb798683ae6727a42dbcf1bc0c02d3ac53fdd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1839db38a2f6db6023ef53e2ebc82cf4fc9cb7154fa0b8bd3628756a93c88b"
  end

  depends_on "libtool" => :build

  # Fixes mp_set_double being missing on macOS.
  # This is needed by some dependents in homebrew-core.
  # NOTE: This patch has been merged upstream but we take a backport
  # from a fork due to file name differences between 1.2.0 and master.
  # Remove with the next version.
  patch do
    url "https://github.com/MoarVM/libtommath/commit/db0d387b808d557bd408a6a253c5bf3a688ef274.patch?full_index=1"
    sha256 "e5eef1762dd3e92125e36034afa72552d77f066eaa19a0fd03cd4f1a656f9ab0"
  end

  def install
    ENV["PREFIX"] = prefix

    system "make", "-f", "makefile.shared", "install"
    system "make", "test"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
