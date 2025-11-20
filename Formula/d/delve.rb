class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "dda9adaafefa469662846d49a82cb7053605bce90bf2986d3f31be6929440ed0"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6587fb615e8b4dd36c02460095951d424f745b663c78b521ab74640789ddcbe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05b92a6ee63c24fcc526ed0cd7694e0c2e4b612106bd5ddbce0c857a67b35098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b92a6ee63c24fcc526ed0cd7694e0c2e4b612106bd5ddbce0c857a67b35098"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05b92a6ee63c24fcc526ed0cd7694e0c2e4b612106bd5ddbce0c857a67b35098"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1abdeab694792837edd47b8690b56221fe9dd276331a00bddf731ff83fd7b28"
    sha256 cellar: :any_skip_relocation, ventura:       "a1abdeab694792837edd47b8690b56221fe9dd276331a00bddf731ff83fd7b28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0aac6d3203dbf6d33ef97f6f9f82ffad10c0ab4a76e012d9b615a8a4c5e9d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d5f85e2ce1893ad6633373f0bd8845c0769ea5a4d9aee719e3234663c342412"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
