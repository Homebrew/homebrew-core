class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.6.tar.gz"
  sha256 "f7e2e9663513234f1be948b426defa12a93916f64377c7a7c88cd5b9c883e8de"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "31fc3d5e11a47a9c40578cf76e4eedcdefdc3dc21214015a0582c885e503b462"
    sha256 cellar: :any,                 arm64_monterey: "004321a90585a62c553aa5d9e05a0444ee4b4e88c1566417d070119213c58ce8"
    sha256 cellar: :any,                 arm64_big_sur:  "24cb69ecfa34e82b39854ebc25e2c26b32a76988709da57505928f732102aea1"
    sha256 cellar: :any,                 ventura:        "4bfde11582135843353fe21728a866e20a5d84d388894caf5fdfd85ff779cda1"
    sha256 cellar: :any,                 monterey:       "dfe34e17fa412145d14c0b9a05f4f5bf1d1ac8e6939d528ba82138d512d434ad"
    sha256 cellar: :any,                 big_sur:        "c8f6066e6af82088abf44cdc97574b7659bac4ceaf878bc5e2e879aa801801aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422bce173e13d86eab8037473aeb6c22028bee2b29de83dc43e595768ecac216"
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
