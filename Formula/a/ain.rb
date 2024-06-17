class Ain < Formula
  desc "HTTP API client for the terminal"
  homepage "https://github.com/jonaslu/ain"
  url "https://github.com/jonaslu/ain/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "dd0037d319085a29c5ba24d50853995f857feda7de482bc9a60887497ce19129"
  license "MIT"
  head "https://github.com/jonaslu/ain.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afed7604cb648c34fb59edbb24aa5801efe3ee9badf176afb598fe901355fef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afed7604cb648c34fb59edbb24aa5801efe3ee9badf176afb598fe901355fef0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afed7604cb648c34fb59edbb24aa5801efe3ee9badf176afb598fe901355fef0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd0c99003bbe544fe7c0db1b7beb6191d22001fa598b28c10a9922e10ab34dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "fd0c99003bbe544fe7c0db1b7beb6191d22001fa598b28c10a9922e10ab34dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "fd0c99003bbe544fe7c0db1b7beb6191d22001fa598b28c10a9922e10ab34dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ec19ee3d3f0e91473bad344b5f2f87f0f82f3f793cff92989069bde404318e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitSha=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ain"
  end

  test do
    assert_match "http://localhost:${PORT}", shell_output("#{bin}/ain -b")
    assert_match version.to_s, shell_output("#{bin}/ain -v")
  end
end
