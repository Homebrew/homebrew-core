class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.7.tar.gz"
  sha256 "574a592bb90c5ae702ffaed1b59498d5e3e7466a8abf8530c5f2f3f11fa4adb3"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93b19975f866077ffd5b2c323b6fe29ad2dfe454f03c628cfbad58df4b4af7c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d808354a764a06427e4768aa451493e111c5324e36fde94fbbab4d7fb41f2055"
    sha256 cellar: :any_skip_relocation, monterey:       "a17d2b11cf873d7d4c7013462c9b4a908b7f5c50eb9b76091c7d48d820530275"
    sha256 cellar: :any_skip_relocation, big_sur:        "50590b93f6f3a25e3e2724ddad696e6ed8a168f840fafe887be423f5020ce86c"
    sha256 cellar: :any_skip_relocation, catalina:       "f592c4bda737ef924fb4c1642fb381db54c9ce246eb51d03a145dd28a8391406"
    sha256 cellar: :any_skip_relocation, mojave:         "6533f0decc607d6e3ce1ad1fdb7f5b30f99bbbcbacbba1bcd880486eef648189"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b6100d066c3cf9d91b2bd4a8d8bcdc5fa453c6eb6a28d7cacb06659baa358e46"
    sha256                               x86_64_linux:   "5bff297fd208a9f97975ffabe9c15b701d8dcafb8ac9a8d552c3c288c7d86dc3"
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", pipe_output("#{bin}/datamash sum 1", shell_output("seq 10")).chomp
  end
end
