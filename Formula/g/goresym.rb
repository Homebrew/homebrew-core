class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "080c3daec100296616f4b0c11b69129b972a1e6a6044a4d73a07d7d7d3c1b442"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4581ec6fca5e798a1998b1514b6df8f8a3f60f96b8ffad2a89fffb657110d223"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4581ec6fca5e798a1998b1514b6df8f8a3f60f96b8ffad2a89fffb657110d223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4581ec6fca5e798a1998b1514b6df8f8a3f60f96b8ffad2a89fffb657110d223"
    sha256 cellar: :any_skip_relocation, sonoma:         "f136d696700e1c2649b39d16063aa27d3322e8afc1c7142b82e7fe53fba953e7"
    sha256 cellar: :any_skip_relocation, ventura:        "f136d696700e1c2649b39d16063aa27d3322e8afc1c7142b82e7fe53fba953e7"
    sha256 cellar: :any_skip_relocation, monterey:       "f136d696700e1c2649b39d16063aa27d3322e8afc1c7142b82e7fe53fba953e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f08a3c48d839a486bb9ad933db336df944816e922861ff7c102d70bb0e3081"
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
