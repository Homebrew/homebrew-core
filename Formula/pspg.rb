class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.4.tar.gz"
  sha256 "1ea5b0b8397a6ed169c6b33afbe617fe2c33820deff6395888c0c8ae2c115d30"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5bf4122f966b50cb6289d7c43c63c2abed7f4c930fb3f3e26beee2309b988c15"
    sha256 cellar: :any,                 arm64_big_sur:  "e9757da03de6ee29718ba9e21c8fd00b41431cefa3e54621771f61b80e29a473"
    sha256 cellar: :any,                 monterey:       "ade05680b72e5fbbb49129ec59640af48509ce05af32af30cd70bfc2f1d24a5d"
    sha256 cellar: :any,                 big_sur:        "1f45c0a7d4be5dc27f11d46ea18daa390e83d3f9af8a37c5d23fb8a563c0f960"
    sha256 cellar: :any,                 catalina:       "af721cce9c59457550514dc94d621b35f0ed686941e3b2ef18fd089417401433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deb4092233bbc760f315f40a46f10d2ae4b4414eb951b2b1ffb9a6ac69436612"
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
