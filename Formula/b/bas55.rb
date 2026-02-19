class Bas55 < Formula
  desc "Minimal BASIC programming language interpreter as defined by ECMA-55"
  homepage "https://jorgicor.niobe.org/bas55/"
  url "https://jorgicor.niobe.org/bas55/bas55-2.0.tar.gz"
  sha256 "640b296df2ee22c2e14e90b23e0edad646682c80b3226652772847fa0614f293"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?bas55[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ee22532aeb40b552f0bcdad959ea9790db7a1256a562d032ea17ec3abf5774c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "478a5356e46bd76319db391d95aff282e41a3864225cede8f1da17a18eeeb055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d2b79dbbfcd253fc6e67a423ebad563b746fb9584ec0ce981575b6a5f1cf427"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f0e68f265df21972857f7978cf48f771eae5196bc1ba27b929ccb75b650b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0104191f7a019cf4e94d968da26e46fd477e4c4e147a690ed890ff7b37b93ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cfc62a8faca260dc7c8f3616083b30792b5fc453a5f082bfc2b7a6ac2b0b42a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e91df7c926416cb91911dc4132e80f8bb22c3789e64475b222591718919dfea8"
    sha256 cellar: :any_skip_relocation, ventura:        "44d2a192051128129fefc7940affd20c3328a7a0585c7af897e1046acccb6fea"
    sha256 cellar: :any_skip_relocation, monterey:       "088b046993c5070926efaca3e3768c724571e788192532fe0647e23d5807c83a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ad23d069a17c47de857d1247335e5372b702da82a9d888c2f4cd46d4d0e96ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "38457e7ed5857d21ccdc44361a8befba24764b9e345f8cbc5aacc46bf7bd2629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687aa791b5bece0576dbe003bc84a50fd8aa65a4ec639b0ee8a16fa8b6702f39"
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
