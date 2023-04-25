class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "395c080997177e07ea31d34f454ad77487518a8e852d257c590bc929ee499f8a"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7190a6da4914ab8e3bdb57a5f3ea8c8f95052a8d255f0a2caecb9f2e4cf4560a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f30d7ccfa3f5f79c84b3cc0a00252048e1576112dfeb50c156a2329625fc7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1152f0b281d3f1790d5099719db9fb4e7514925c5532e13ea9bcfcefa93a025f"
    sha256 cellar: :any_skip_relocation, ventura:        "62a21be5367aaf5ce1c5432902b6d1a68e359b9dd16baa6ca25196dbe2a697b4"
    sha256 cellar: :any_skip_relocation, monterey:       "00fbfd34e30c2b392c7618b3f463a379160ff3b2f64b4e50a656a604cbdb9bea"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6f5da31f1297d8d71ae2416e81f1a28ea905b305a43bd14e426b6c84832d044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd57e99b42fdcd29adbbe5cf0156954f7ea210e940800fa8e5ac69edf7b123c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
