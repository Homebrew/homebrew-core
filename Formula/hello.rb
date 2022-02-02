class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.12.tar.gz"
  sha256 "cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be8bba73844b60a684885c91b61bd131a8655ae5b1d748dd7562f878e78fa8f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d1e1b66826f3e5b9767af9f2fad00e5395a0c559519d4a55a0136518c81dbd"
    sha256 cellar: :any_skip_relocation, monterey:       "f7883fe8258feef2ff49fc3b2f8c7a9665a6c51afe34042b7dcb69d805b1376b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e4325a96ed1cbfe67a93a4df85b0edb1aa8d55a7d2c33396b95801b2d6dc047"
    sha256 cellar: :any_skip_relocation, catalina:       "9f70c809590bc170cd73273c95f21bb1b78c7bd9d0b9cbb8b191f17ff7ce8be6"
    sha256                               x86_64_linux:   "d5a213b36a6dedc2dc2194e364e65f74208e7ea46fbd78d2442791e703a61e7a"
  end

  conflicts_with "perkeep", because: "both install `hello` binaries"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
