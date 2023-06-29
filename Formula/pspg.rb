class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.8.tar.gz"
  sha256 "efa9225f717eef25e5e59e8957a0a9720a111f7d1e5f02c38bd36148a31dffae"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "07abdd59f2f50629b4de3992fc7866637d22d7bd55822effd684a624fa4b0049"
    sha256 cellar: :any,                 arm64_monterey: "bfab274d35d85cb3cbc44e8b83171f0820d18e70ae06027cf362a585b7a34dd6"
    sha256 cellar: :any,                 arm64_big_sur:  "bfde20bcacd0680423fb1179e79f75bdebb47234cc8a961723db663450d4762f"
    sha256 cellar: :any,                 ventura:        "8130a9d778890b3a51a3fd53dd7bdc5c96afc67500fba9b2761d1ecd2a0671b1"
    sha256 cellar: :any,                 monterey:       "88c51fc1793ed6ebe6f28c8fc6a6b02e5b5405f2075f1ad8d766042c71393d04"
    sha256 cellar: :any,                 big_sur:        "0eaf8b878fe0f1e3ec1ef049ab50c9947dc1a309b6b985db241d7ecc5034b949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f773cf98e373e7840a1596559a47a82ab1d4a5feecfa533f08e1e1998e4ca09a"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
