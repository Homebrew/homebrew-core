class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "5ed82506ca6d79968c6dfe3ac721a14ca886a19394228c2dce71ef69941aea90"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879de704173f2e066df717c6190b178f0a188b709a6c3f5e315c714ea74592ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf2b47031c6261e1d977bf293fb452485fea96cc206a6f3027ec7e18f86e04a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acf2b47031c6261e1d977bf293fb452485fea96cc206a6f3027ec7e18f86e04a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acf2b47031c6261e1d977bf293fb452485fea96cc206a6f3027ec7e18f86e04a"
    sha256 cellar: :any_skip_relocation, sonoma:        "91cbad4c26d47b16a46c27d48cc9798bca37915f72870ba29fb3a069bafa3295"
    sha256 cellar: :any_skip_relocation, ventura:       "91cbad4c26d47b16a46c27d48cc9798bca37915f72870ba29fb3a069bafa3295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7e30fb975d2d32fa76af54e04edc2b138b8b878b9c5e13fd1bd74d0e3322f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6414715ef12ade766c4e58fe223f6a341c4fbde88bf69495260bde6e100870b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
