class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.3.tar.xz"
  sha256 "7b6605e48d1a49f43cc4b4cfc59f313d0dd5402fa40b96810bd572e167dfed0f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "854e71038ba45a258bd05e853fd112571677f5da98848b2f867a0c63de123ebe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe623d78be3c9dfad5ca28dbb96f7f6d048a191f670f810921b2cf624fb59c9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42898660d945bc7599a98c515c55e3cfa3f4e229484af336f706aa5591089ca5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5b3a0c36b58751871cbf1a70003101aaff0acf6813aed77129418b99dbcd446"
    sha256 cellar: :any_skip_relocation, ventura:        "498225ee7af6affad1a791542e3ca534fd68818a6565abcdc5090597b2976965"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e02614d017db903671edc2a83d97dbfe7eb64bfcf1888e73591b1830a258f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c84c1512548321cb7c2aa649f9ac3139cec518b8b579eaf9856b940e8f07c0"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
    doc.install "misc-utils/getopt-example.bash", "misc-utils/getopt-example.tcsh"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
    # Check that getopt is enhanced
    quiet_system "#{bin}/getopt", "-T"
    assert_equal 4, $CHILD_STATUS.exitstatus
  end
end
