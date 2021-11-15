class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "https://bogofilter.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-stable/bogofilter-1.2.5.tar.xz"
  sha256 "3248a1373bff552c500834adbea4b6caee04224516ae581fb25a4c6a6dee89ea"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "25e3974a7aa8d9dcc2c3e95b85e7a4e9abba388adf54470dcfd705d29ba3c6d1"
    sha256 cellar: :any,                 arm64_big_sur:  "2206ad532a38d489deb48bb9cafec00c9b98a09f621f7f208f95cc36387dafb4"
    sha256 cellar: :any,                 monterey:       "89d4f31cd57d801d99a68950682b746c490b481891bfb904f173270f13fc751f"
    sha256 cellar: :any,                 big_sur:        "d6ad409edcabed2d32cc945c36151b3a0ae17258d9430f3192b912f1dd1050e8"
    sha256 cellar: :any,                 catalina:       "2f2d4c414683f922e687d054e71619a0455560aac2522484132099fbddcc6a77"
    sha256 cellar: :any,                 mojave:         "d7df5e0d29f4fcbc9eafc129ddfd993dc785ee3a4bf79b70b0dce9b5f31f7be4"
    sha256 cellar: :any,                 high_sierra:    "c7998fa1651590e6aaf27f8fe014a7b0e305a48a02de4cdcb9ba53f1c84bd1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a74a36fca55ff920b663466e33ed22a127726da33b90f26b45abcc084074f33"
  end

  depends_on "berkeley-db"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bogofilter", "--version"
  end
end
