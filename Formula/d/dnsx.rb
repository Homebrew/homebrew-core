class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "fa9ee47996315b0d5b293fcf9263ac46ee69fc691ee024a400ebcd2e48f015e5"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3d4a589a196ec79ac31875af9b77b6cbbef8823e58efe67e5ca373400696663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d813ed83eff13bfb735313c3f83d9623c20725eb1595c07b0e2f1dbefc929f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe3bf442070686cb1a099ce4cd5e5f96a6f4629aa067c6af56e0e3173b6facff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "417e501ba0b141aef16653a4ff5decdb000095528f6ece7992fc328c453e0a78"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ecccf054559abc48f1657926ab611a679487b8b61f9c9f07b89482ff43a560"
    sha256 cellar: :any_skip_relocation, ventura:       "7b7ac5247f6c526bffa28726658c3853e1fc17cc717e5d6785dd47f0ce3401ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e82600dba097d60f52a2c94cadb674adbf65fbdd07461cdcc5c2bbfc706ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a9d8baefa0608d03aa71b6eb94ab58fa6c2261495fcea61b376459d272dbec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [CNAME] [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -no-color -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
