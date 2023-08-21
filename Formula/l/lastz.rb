class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https://lastz.github.io/lastz/"
  url "https://github.com/lastz/lastz/archive/refs/tags/1.04.22.tar.gz"
  sha256 "4c829603ba4aed7ddf64255b528cd88850e4557382fca29580d3576c25c5054a"
  license "MIT"
  head "https://github.com/lastz/lastz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78b2de045fb9e026d2d83f13711c67109c2e0b76acbd9a3e55ce589e4d74156b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0079336e54ddda2906063ae8e1345c285b907945ee992908bf2911298995a9e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "869cf05ab0957ebf07fda9c95fe6e853610383a07f85f93a0b8efbd0a412b642"
    sha256 cellar: :any_skip_relocation, ventura:        "76da49110084c31baa426e5c5c5668ea70666680f17520a9e1d1bafa3d3010ec"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce7a7414d2cda02aa35efe3b9dfe418c8b6cdda4b58322a5554488c79a2d85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbf2688ff167ad24a18a218b1ba24175d06a9ea1a13f63914565b240848250ab"
    sha256 cellar: :any_skip_relocation, catalina:       "9870cfbbcdee4b2512ef695f80c5bbc4f15bbbb98738009c7d7ea1a936016020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d6ba10ae062a21f3538006e2415897b089d50f264a6e048a81f210765435e3"
  end

  def install
    system "make", "install", "definedForAll=-Wall", "LASTZ_INSTALL=#{bin}"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}/lastz --help=formats", 1)
    dir = pkgshare/"test_data"
    assert_match "#:lav", shell_output("#{bin}/lastz #{dir}/pseudocat.fa #{dir}/pseudopig.fa")
  end
end
