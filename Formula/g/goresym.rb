class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "e11938947cd7de1a7a69cc88826c0dbd413efd2ad847580772312b5e9a273311"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2bc5b5d8e11a0e4ff2edea34e724ba2e05bc783010ed3ef1fe419f6a19fcc68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2bc5b5d8e11a0e4ff2edea34e724ba2e05bc783010ed3ef1fe419f6a19fcc68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2bc5b5d8e11a0e4ff2edea34e724ba2e05bc783010ed3ef1fe419f6a19fcc68"
    sha256 cellar: :any_skip_relocation, sonoma:         "495a18531b5b85503e59c930a8fe107245072182b291a799e5fbe6f6db1bac3b"
    sha256 cellar: :any_skip_relocation, ventura:        "495a18531b5b85503e59c930a8fe107245072182b291a799e5fbe6f6db1bac3b"
    sha256 cellar: :any_skip_relocation, monterey:       "495a18531b5b85503e59c930a8fe107245072182b291a799e5fbe6f6db1bac3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8186adaf6e40843d8df33a926f2b525f1ee210292b972bc182438f5f37e0b936"
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
