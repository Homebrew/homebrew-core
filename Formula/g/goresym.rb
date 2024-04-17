class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "c731fdda4bab701f2348bd204b9d99fb90e97d73518278b7459b61df1983f0a1"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6e4cb831c543865ae0ee09273b6a30d8c099e55efcd387758899dff3f25657f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e4cb831c543865ae0ee09273b6a30d8c099e55efcd387758899dff3f25657f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e4cb831c543865ae0ee09273b6a30d8c099e55efcd387758899dff3f25657f"
    sha256 cellar: :any_skip_relocation, sonoma:         "861ec57565d01c6cf9ec24db47ced36ec3b3b7975ddc27e6510ed2bef3dbd0d8"
    sha256 cellar: :any_skip_relocation, ventura:        "861ec57565d01c6cf9ec24db47ced36ec3b3b7975ddc27e6510ed2bef3dbd0d8"
    sha256 cellar: :any_skip_relocation, monterey:       "861ec57565d01c6cf9ec24db47ced36ec3b3b7975ddc27e6510ed2bef3dbd0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9301b3296add22750840c35fc09de608e4e5173f437b46408ea28b779d502507"
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
