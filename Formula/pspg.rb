class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.0.tar.gz"
  sha256 "db80f40bbc1355bb301374920862b34acae2eefb334ef53edf8b8b7dcb788110"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b02f6763c782e3e90cb73cfa9e2e0271cfa35a7a26c5d47d01beb37612482c7e"
    sha256 cellar: :any,                 arm64_monterey: "32f781e5d13ca1eca1f2c9026e9a85240bca4093b044f371a78a2da92c216ad8"
    sha256 cellar: :any,                 arm64_big_sur:  "31014559f6218880043545d9ba52eed4714a465ff7f1df8d3e1ae9581230911e"
    sha256 cellar: :any,                 ventura:        "2db0f83dce1fa917208bf7e6894842b09346c568dd13263a7f1b73f5d89afaf7"
    sha256 cellar: :any,                 monterey:       "f919eec567afb03adbd962c8b9fe7bfc15a360467556253cba35f11eb8682b4d"
    sha256 cellar: :any,                 big_sur:        "67c6b033c9e71f2673bb4bca7958c84fdeebce0ced551e7792b013aa40bb7678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba2f6078b8eb3f5862b836b45aad35f19b78c387cfae3ed5378768ec9f1fed7b"
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
