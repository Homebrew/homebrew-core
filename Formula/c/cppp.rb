class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "https://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "https://www.muppetlabs.com/~breadbox/pub/software/cppp-2.9.tar.gz"
  sha256 "76a95b46c3e36d55c0a98175c0aa72b17b219e68062c2c2c26f971e749951c07"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cppp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "29bae12103813789942c21786cc253702a2d5eae6baeff11561afc12bbafde7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4b14311322cdff7ec30e93ba573bf916eae962c7d2488e7f85a88a4b8bead0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2fe122f6b616feaab1f4ef815061564ace5069c55fdc8c5fc568a35bb6e2fec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f812c4083a5ef978178a692f617081b97377aaf2f8fb063cc49abecc65538f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1926109416735a823a7ab9a534be30f4c5a64f9cc72d36b52e125c70f8d28d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32559caedf75a13cad737826acd6d83b2d7e8cc69c5ecc18bdaecb37856d5a26"
    sha256 cellar: :any_skip_relocation, sonoma:         "3061445285d21e97da5f8e8e67207ffc7443f5dd08e4fbeacd7dbe06ba8fbece"
    sha256 cellar: :any_skip_relocation, ventura:        "dcc13b4d0b56a0b9b880254b8c0771b9734f6c41804fe9da6b51d5e5cfaa647f"
    sha256 cellar: :any_skip_relocation, monterey:       "f815f392d7b8ec92a327c2d543bf962a70cae5f1f6991e1e4d695ee25c1fecb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "549a5a56c7173307a1fe50415ac029d31ffa80d4aba09bca2c387dff8b6fd71e"
    sha256 cellar: :any_skip_relocation, catalina:       "539d3f0e5376e354018c7d91eb458194fc2654785af7075bb646584618493f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "37b5825a280e3bdc38d0c6269d58195cc091002b0404427fd8c7c45f59a8542a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb41f54440bb5ee1dc17adb0729f4577dbe156e2c63548becd5d0cc5abd2691"
  end

  def install
    system "make"
    bin.install "cppp"
  end

  test do
    (testpath/"hello.c").write <<~C
      /* Comments stand for code */
      #ifdef FOO
      /* FOO is defined */
      # ifdef BAR
      /* FOO & BAR are defined */
      # else
      /* BAR is not defined */
      # endif
      #else
      /* FOO is not defined */
      # ifndef BAZ
      /* FOO & BAZ are undefined */
      # endif
      #endif
    C
    system bin/"cppp", "-DFOO", "hello.c"
  end
end
