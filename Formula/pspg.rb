class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.2.1.tar.gz"
  sha256 "2fb3a25ebfb9f865ee18862fa5fe612ccdac67ad82ed883396f465833e18950f"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "845813f8d4dbe82201c71e40a94cfe36b1cc00be7638d908b21da5d2a2c465b6"
    sha256 cellar: :any,                 big_sur:       "380048d8a717fc08269573e685fd270f774ea3014db11c38463eefded759e68b"
    sha256 cellar: :any,                 catalina:      "79427b631aa1557e2ff91b1de046e2cf3f6f82b9c69141be76570f73ceb54366"
    sha256 cellar: :any,                 mojave:        "76c871cbcdf906402479fc0f7fb411cd598075a8e3be2aa866074c863a68f2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccefb8fab4e9bfed59ac312a681f9292d3e699990272fec674fb2b4e69e38b21"
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
