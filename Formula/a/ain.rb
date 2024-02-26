class Ain < Formula
  desc "HTTP API client for the terminal"
  homepage "https://github.com/jonaslu/ain"
  url "https://github.com/jonaslu/ain/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "af77c16f50a0ee2439f984e126b3b14da6efbd224617c59ca8ccffd62dbf11b9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea25b30846e0726917a3657c40e6ea27f1ff562de9fea12c521df1e3350c5918"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea25b30846e0726917a3657c40e6ea27f1ff562de9fea12c521df1e3350c5918"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea25b30846e0726917a3657c40e6ea27f1ff562de9fea12c521df1e3350c5918"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e06f44649af98a5b34a120f52dc20175932fe35b634566d7387e302ab9808dd"
    sha256 cellar: :any_skip_relocation, ventura:        "5e06f44649af98a5b34a120f52dc20175932fe35b634566d7387e302ab9808dd"
    sha256 cellar: :any_skip_relocation, monterey:       "5e06f44649af98a5b34a120f52dc20175932fe35b634566d7387e302ab9808dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939940932807210dfe45f6bb26c9a43dac10e77003670841a1f92a94b8635246"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitSha=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ain"
  end

  test do
    assert_match "http://localhost:${PORT}", shell_output("#{bin}/ain -b")
    assert_match version.to_s, shell_output("#{bin}/ain -v")
  end
end
