class Bas55 < Formula
  desc "Minimal BASIC programming language interpreter as defined by ECMA-55"
  homepage "https://jorgicor.niobe.org/bas55/"
  url "https://jorgicor.niobe.org/bas55/bas55-1.19.tar.gz"
  sha256 "566097e216dab029d51afefdacf7806f249d57d117ca3e875e27c6cf61098ee0"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?bas55[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7789ffd65c9afc8d415385c439205a62e369c598bd6cc7b9133e306cff8a5be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab48670d6620654c1e88b8076d9c9805e6f6b2fde8f1d8773ac96fd5bd234789"
    sha256 cellar: :any_skip_relocation, monterey:       "2696588487bbff56058e0370ec09b63143f5e12c1206490066d7b213d57260db"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9a50cf6904cafd3a75cbb762ea68d3545eadc832be0b2c0313aaadf03dfe453"
    sha256 cellar: :any_skip_relocation, catalina:       "7eaaf506f35bbc8f2149028c7b379f3b5fc7d5bd7899d021b016f94272e9441e"
    sha256 cellar: :any_skip_relocation, mojave:         "1c7f697e391226ba6ba292cdb80801b2b221ed355918fa6ef14deb61abbb73ac"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.bas").write <<~EOS
      10 PRINT "HELLO, WORLD"
      20 END
    EOS

    assert_equal "HELLO, WORLD\n", shell_output("#{bin}/bas55 hello.bas")
  end
end
