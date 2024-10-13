class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-5.2.tar.gz"
  sha256 "a7692d10d73fb0bb76e1f7459aa7f19bbcdbfc5adbedef02f468974b18b0e42f"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?fping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5a1d7975f60df86c80b264d204c5477e93d4075c62b85fd206bf8fa9f6793b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4423ec7fed15ac1c3c77b38e94a558509cdd653e7c8c8a6f5614bd1a1440b205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af03b2f649dc3f6dd40665bdaa3ad678072b520f8fcee99adffa3c37e8308c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be35f1c21a4d9bb9ec325098f1657525517c8e8a0145edbd0be4745a93d2aefe"
    sha256 cellar: :any_skip_relocation, sonoma:         "4502b4d3010674df0e2b12a176e70dfef11755f955cc7d40849d933984d632d1"
    sha256 cellar: :any_skip_relocation, ventura:        "55b47df6f6aefd32e91638b0c079176cbd852cac55aa5f1c70456e516ceebc7c"
    sha256 cellar: :any_skip_relocation, monterey:       "81505d83664af7408ce69debeaff2612316c3b356b696e4935e9e96052459e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca9f76165721fab77165b38b482909fd28e6460cc3fd39b5c072a25f5d4684f"
  end

  head do
    url "https://github.com/schweikert/fping.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fping --version")
    assert_match "Probing options:", shell_output("#{bin}/fping --help")
    assert_equal "127.0.0.1 is alive", shell_output("#{bin}/fping -4 -A localhost").chomp
  end
end
