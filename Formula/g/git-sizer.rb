class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "2c6355a9ccdaa6bbe03fa309e087483961afefcfbf354491a419e1d5e6c1bbd1"
  license "MIT"
  head "https://github.com/github/git-sizer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f57eb07ee7927a6697de207a68741289aa1f811885342732c58b1b948a2b10e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f57eb07ee7927a6697de207a68741289aa1f811885342732c58b1b948a2b10e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f57eb07ee7927a6697de207a68741289aa1f811885342732c58b1b948a2b10e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3614c4262825771af8c8abbaffde1f18227ab02ec21891b7c6d38c6add44aa0"
    sha256 cellar: :any,                 x86_64_linux:      "b5dd2b8b88d3f53be8dfabe56184deef28636e108ae186c871dec5b8f8149dfa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.ReleaseVersion=#{version}")
  end

  test do
    system "git", "init"
    output = shell_output(bin/"git-sizer")
    assert_match "No problems above the current threshold were found", output
  end
end
