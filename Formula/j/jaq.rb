class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "eee6a4d608c31c12c82644f1cdb69cfed55bb079806ec939e4de486bb252c631"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5fb67c8d1014124d11de2509cdd4193ff9bd3b40b034878fb9244c671884cbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c879bede80cf5b1368482ee0659d59478cfe7a48d05fe958db960d5e01bb12d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ede9e60aedafe42af2686ca6a0de41e620aa793bddb0134762e2d2f731d00fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ce17f8a15fa650fc1d9f2409b863a3d0a7946dd4c919dd6ece16cf384de48eb"
    sha256 cellar: :any_skip_relocation, ventura:       "0e29a1adffb625f5187d09689a5ad00408051df7ed6505f0803814c1899549de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ce9eeae10703d67e1ff25ae18e5fcee03b5d76712a37c89fd98a24663354df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de05dc546a03d574196873f8b4483f401607e1d5e6549d5636779d75dd94ee22"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
