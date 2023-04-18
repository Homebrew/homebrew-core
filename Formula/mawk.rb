class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20230404.tgz"
  sha256 "5a8260b1adda00bad8e40ba89fa20860c5b6e1393089dd1c7a6126aa023e9f63"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf97c1ca4817d7f50c5b760c2b4801d1a581daabdd4d7ccdaa591e81dd6c1194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0bac88b98266a92b3c44f44c86bbe6331c84de6fa66698a2f305b3244ec0f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb64075469ce97f8f0d58e4e866179bc9f4f4968c31862b5d90c1ae8cc767c0c"
    sha256 cellar: :any_skip_relocation, ventura:        "94c2b98318386ed525b90ce62f1b6185714e4653ce93394507679268a8711ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "1a42301b274941c4e4abe8b13dd905a38859600ed700107c1f29bdc96128ff61"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0291d58a0a36c42a21134986b7fd75971d29faf629011b73526bee28ae2bb93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a2204db237fdc5bf10711b691db0ae7e2087cc655b776b7decc76e0030293b"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
