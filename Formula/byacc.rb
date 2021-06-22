class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20210619.tgz"
  sha256 "acdd6080dcf935732a08ec8e8c4c161c666cd56d8c490739c6dbb6267a498c0e"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "651946ffc2c12bbd541d7abcfa0679bf390e9478a8d01f1933ec29723e883c53"
    sha256 cellar: :any_skip_relocation, big_sur:       "e12e6e46d3fdf86b1ad7831b1abea455fad76cc036758912dab27cfbe9ce9eeb"
    sha256 cellar: :any_skip_relocation, catalina:      "4d6c32e17bea48b6835cb6b1a091f39a55a047900d25b1e898573685b9209bf5"
    sha256 cellar: :any_skip_relocation, mojave:        "694539f58ff6b4949adb90b697aa90bd9463a5c6062a61f8622f27006f02605e"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
